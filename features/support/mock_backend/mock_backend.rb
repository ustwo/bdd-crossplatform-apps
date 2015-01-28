require 'json'
require 'grape'
require 'socket'

require_relative '../commands/bootup_server_command'

module GitHubMockBackend
    class API < Grape::API

    version 'v1', using: :header, vendor: 'ustwo'
    format :json

    @@requests = []
    @@repo_json = nil
    @@commit_json = nil
    @@commits_json = nil
    @@request_delay = nil

    before do
      @@requests << request

      if !@@request_delay.nil?
        sleep @@request_delay
      end
    end

    get '/repos/:org/:repo' do
      if @@repo_json.nil?
        @@repo_json = API.static_json('default_repo')
      else
        @@repo_json
      end
    end

    get '/repos/:org/:repo/commits' do
      if @@commits_json.nil?
        @@commits_json = API.static_json('default_commits')
      else
        @@commits_json
      end
    end

    get '/repos/:org/:repo/commits/:commit' do
      if @@commit_json.nil?
        @@commit_json = API.static_json('default_commit')
      else
        @@commit_json
      end
    end

    get '/' do
      content_type 'text/plain'
      body 'Hello World'
    end

    # Called after every scenario
    def self.init
      @@requests = []
      @@repo_json = nil
      @@commits_json = nil
      @@request_delay = nil
    end

    def self.set_request_delay delay
      @@request_delay = delay
    end

    def self.get_repo_json
      @@repo_json
    end

    def self.get_commits_json
      @@commits_json
    end

    def self.set_repo_json file_name
      @@repo_json = API.static_json(file_name)
    end

    def self.set_commits_json file_name
      @@commits_json = API.static_json(file_name)
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

    @@boot = nil

    def initialize

      host = Bind.host
      port = Bind.port
      full_url = Bind.url

      puts "About to boot up mock server at: #{full_url}"

      @bootup = BootupServerCommand.new(host, port)
      @bootup.execute

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
      @bootup.close
      puts "Mock server finished"
    end

    def self.boot
      @@boot = Boot.new
    end

    def self.exit
      if !@@boot.nil?
        @@boot.close
      end
    end
  end
end
