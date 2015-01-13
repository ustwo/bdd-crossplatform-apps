require 'json'
require 'grape'

module GitHubMockBackend

  class API < Grape::API

    version 'v1', using: :header, vendor: 'ustwo'
    format :json

    get '/repos/:org/:repo' do
      API.static_json('default_repo')
    end

    get '/repos/:org/:repo/commits' do
      API.static_json('default_commits')
    end

    get '/' do
      content_type 'text/plain'
      body 'Hello World'
    end

    def self.static_json(file_name)
      file_path = File.read("#{File.dirname(__FILE__)}/responses/json/#{file_name}.json")
      JSON.parse(file_path)
    end

  end

  class Bind

    def self.host

      # mix of these two:
      # http://stackoverflow.com/questions/14019287/get-the-ip-address-of-local-machine-rails
      # http://stackoverflow.com/questions/5029427/ruby-get-local-ip-nix

      Socket.ip_address_list.find { |a| a.ipv4? && !a.ipv4_loopback? }.ip_address
    end

    def self.port
      9999
    end

    def self.url
      "http://#{Bind.host}:#{Bind.port}"
    end
  end

  class Boot

    def initialize

      config_ru_path = 'features/support/mock_backend/config.ru'
      full_url = Bind.url

      puts "About to boot up mock server at: #{full_url}"

      host = Bind.host
      port = Bind.port

      @stdin, @stdout, @stderr, @wait_thr = Open3.popen3("shotgun -o #{host} -p #{port} #{config_ru_path}")
      @pid = @wait_thr[:pid]

      puts "Mock server PID: #{@pid}"

      while true

        begin
          break if HTTParty.get(full_url).response.code.to_i == 200
        rescue
          puts 'Waiting for mocked backend'
        end

        sleep 0.5
      end

      puts "Mock server up and running"
    end

    def close
      @stdin.close
      @stdout.close
      @stderr.close

      `kill -9 #{@pid}`

      puts "Mock server finished"
    end

    def self.boot
      @@boot = Boot.new
    end

    def self.exit
      @@boot.close
    end
  end
end
