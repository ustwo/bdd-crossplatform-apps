require 'json'
require 'grape'
require_relative '../commands/shotgun_command'

module GitHubMockBackend
    class API < Grape::API

    version 'v1', using: :header, vendor: 'ustwo'
    format :json

    @@requests = nil

    before do

      @@requests = [] if @@requests == nil
      @@requests << request

      puts ">>> #{request.fullpath}"
    end

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

    def self.get_requests
      @@requests
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

      @shotgun = ShotgunCommand.new(host, port, config_ru_path)
      @shotgun.execute
      puts "Mock server PID: #{@shotgun.pid}"

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
      @shotgun.close
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
