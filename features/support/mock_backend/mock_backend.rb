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
    @@forced_body = nil
    @@forced_status = nil
    @@forced_type = nil
    @@request_delay = nil
    @@error_json = nil

    before do
      @@requests << request

      if !@@request_delay.nil?
        sleep @@request_delay
      end

      if !@@forced_type.nil?
        content_type @@forced_type
      end

      if !@@forced_status.nil?
        status @@forced_status
      end

      if !@@forced_body.nil?
        body @@forced_body
      end

      if !@@error_json.nil?
        error!(@@error_json)
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

    # Below this point there is the API used to
    # force specific mock server behaviours such as
    # slow responses, broken JSON responses, etc

    # Each endpoint can be easily called from the steps
    # through static methods at the bottom

    # Called before and after every scenario
    # to be sure there are no leftovers from previous tests
    get '/init' do
      @@requests = []
      @@repo_json = nil
      @@commit_json = nil
      @@commits_json = nil
      @@forced_body = nil
      @@forced_status = nil
      @@forced_type = nil
      @@request_delay = nil
      @@error_json = nil
      {}
    end

    post '/request_delay' do

      delay = params[:delay].to_i
      @@request_delay = delay
      {}
    end

    get '/repo_json' do
      @@repo_json
    end

    get '/commits_json' do
      @@commits_json
    end

    post '/repo_json' do
      file_name = params[:filename]
      @@repo_json = API.static_json(file_name)
      {}
    end

    post '/commits_json' do
      file_name = params[:filename]
      @@commits_json = API.static_json(file_name)
      {}
    end

    post '/response' do
      @@forced_body = (params[:body].empty?)? nil : params[:body]
      @@forced_status = (params[:status].empty?)? nil : params[:status]
      @@forced_type = (params[:type].empty?)? nil : params[:type]
      {}
    end

    get '/requests' do

      requests = []

      @@requests.each do |request|
        requests << {fullpath: request.fullpath} unless request.fullpath == '/requests'
      end

      requests
    end

    # ####################

    def self.init
      HTTParty.get(Bind.url + '/init')
    end

    def self.set_request_delay delay
      HTTParty.post(Bind.url + '/request_delay', body: {delay: delay})
    end

    def self.get_repo_json
      response = HTTParty.get(Bind.url + '/repo_json')
      JSON.parse(response.body)
    end

    def self.get_commits_json
      response = HTTParty.get(Bind.url + '/commits_json')
      JSON.parse(response.body)
    end

    def self.set_repo_json file_name
      HTTParty.post(Bind.url + '/repo_json', body: {filename: file_name})
    end

    def self.set_response body: nil, status: nil, type: nil
      HTTParty.post(Bind.url + '/response', body: {body: body, status: status, type: type})
    end

    def self.set_commits_json file_name
      HTTParty.post(Bind.url + '/commits_json', body: {filename: file_name})
    end

    def self.get_requests
      response = HTTParty.get(Bind.url + '/requests')
      JSON.parse(response.body)
    end

    def self.file_content(file_name)
      File.read("#{File.dirname(__FILE__)}/responses/json/#{file_name}.json")
    end

    def self.static_json(file_name)
      JSON.parse(file_content(file_name))
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

      if self.is_running?
        puts "Mock server already running at #{full_url}."
      else

        puts "About to boot up mock server at: #{full_url}"

        @bootup = BootupServerCommand.new(host, port)
        @bootup.execute

        while true

          break if self.is_running?
          puts 'Waiting for mock backend'
          sleep 0.5
        end

        puts "Mock server up and running"
      end
    end

    def is_running?
      begin
        HTTParty.get(Bind.url).response.code.to_i == 200
      rescue
        false
      end
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
