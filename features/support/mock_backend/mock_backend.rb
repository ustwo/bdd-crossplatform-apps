require 'json'
require 'grape'
require 'socket'

require_relative '../commands/bootup_server_command'

module GitHubMockBackend
  class API < Grape::API

    version 'v1', using: :header, vendor: 'ustwo'
    format :json

    # TODO: could this be read into a Pstore instead of class vars?
    @@requests = []
    @@repo_json = nil
    @@commit_json = nil
    @@commits_json = nil
    @@forced_body = nil
    @@forced_status = nil
    @@forced_type = nil
    @@request_delay = nil
    @@error_json = nil

    before do
      @@requests << request
      sleep @@request_delay unless @@request_delay.nil?
      content_type @@forced_type unless @@forced_type.nil?
      status @@forced_status unless @@forced_status.nil?
      body @@forced_body unless @@forced_body.nil?
      error!(@@error_json) unless @@error_json.nil?
    end

    get '/repos/:org/:repo' do
      @@repo_json ||= API.static_json('default_repo')
    end

    get '/repos/:org/:repo/commits' do
      @@commits_json ||= API.static_json('default_commits')
    end

    get '/repos/:org/:repo/commits/:commit' do
      @commit_json ||= API.static_json('default_commit')
    end

    get '/' do
      content_type 'text/plain'
      body 'Hello World'
    end

    # Called after every scenario
    def self.init
      @@requests = []
      @@repo_json = nil
      @@commit_json = nil
      @@commits_json = nil
      @@forced_body = nil
      @@forced_status = nil
      @@forced_type = nil
      @@request_delay = nil
      @@error_json = nil
    end

    def self.set_request_delay(delay)
      @@request_delay = delay
    end

    def self.get_repo_json
      @@repo_json
    end

    def self.get_commits_json
      @@commits_json
    end

    def self.set_repo_json(file_name)
      @@repo_json = API.static_json(file_name)
    end

    def self.set_commits_json(file_name)
      @@commits_json = API.static_json(file_name)
    end

    def self.set_response(body: nil, status: nil, type: nil)
      @@forced_body = body
      @@forced_status = status
      @@forced_type = type
    end

    def self.file_content(file_name)
      File.read("#{File.dirname(__FILE__)}/responses/json/#{file_name}.json")
    end

    def self.static_json(file_name)
      JSON.parse(file_content(file_name))
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

    def initialize(stop_if_running)
      host = Bind.host
      port = Bind.port
      full_url = Bind.url

      if self.is_running?
        if stop_if_running
          abort("ERROR: Mock server already running at #{full_url}. Please stop it and run this again.")
        else
          puts "Mock server already running at #{full_url}."
        end
      else
        puts "About to boot up mock server at: #{full_url}"

        @bootup = BootupServerCommand.new(host, port)
        @bootup.execute

        loop do
          break if self.is_running?
          puts 'Waiting for mock backend'
          sleep 0.5
        end

        puts "Mock server up and running"
      end
    end

    def is_running?
      HTTParty.get(Bind.url).response.code.to_i == 200
      rescue
        false
      end
    end

    def close
      @bootup.close
      puts "Mock server finished"
    end

    def self.boot(stop_if_running: true)
      @@boot = Boot.new(stop_if_running)
    end

    def self.exit
      @@boot.close unless @@boot.nil?
    end
  end
end
