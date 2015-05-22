require 'json'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'

require_relative 'utils'

module GitHubMockBackend
  # Web server implementing a subset of the GitHub API.
  # Mostly returns static JSON files store in ```responses/json```.
  # It has a 'backdoor' API that allows to force specific responses, error codes, etc., see API for more info.
  class Server < Sinatra::Base
    @@requests = []
    @@repo_json = nil
    @@commit_json = nil
    @@commits_json = nil
    @@forced_body = nil
    @@forced_status = nil
    @@forced_type = nil
    @@request_delay = nil
    @@error_json = nil

    configure do
      register Sinatra::Reloader
    end

    helpers do
      def empty_json
        JSON.parse('{}')
      end

      def backdoor_api(fullpath)
        [
          '/',
          '/init',
          '/request_delay',
          '/repo_json',
          '/commits_json',
          '/response',
          '/requests'
        ].include?(fullpath)
      end
    end

    before do
      # NOTE (JD): We don't mess around with requests to the backdoor API.
      # This means we don't log them, delay them, force their status, etc.
      return if backdoor_api(request.fullpath)

      @@requests << request

      sleep @@request_delay unless @@request_delay.nil?
      content_type @@forced_type unless @@forced_type.nil?
      status @@forced_status unless @@forced_status.nil?
      body @@forced_body unless @@forced_body.nil?
      error!(@@error_json) unless @@error_json.nil?
    end

    # Returns repo JSON file.
    get '/repos/:org/:repo' do
      if @@repo_json.nil?
        @@repo_json = Utils.static_json(file_name: 'default_repo')
      else
        @@repo_json
      end

      json(@@repo_json)
    end

    # Returns repo's commit JSON file.
    get '/repos/:org/:repo/commits' do
      if @@commits_json.nil?
        @@commits_json = Utils.static_json(file_name: 'default_commits')
      else
        @@commits_json
      end

      json(@@commits_json)
    end

    # Returns a commit JSON file.
    get '/repos/:org/:repo/commits/:commit' do
      if @@commit_json.nil?
        @@commit_json = Utils.static_json(file_name: 'default_commit')
      else
        @@commit_json
      end

      json(@@commit_json)
    end

    # NOT part of the official API, just a helper to know we are up and running.
    get '/' do
      'Hello World'
    end

    # Below this point there is the API used to
    # force specific mock server behaviours such as
    # slow responses, broken JSON responses, etc

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
      json(empty_json)
    end

    post '/request_delay' do
      @@request_delay = params[:delay].to_i
      json(empty_json)
    end

    get '/repo_json' do
      json(@@repo_json)
    end

    get '/commits_json' do
      json(@@commits_json)
    end

    post '/repo_json' do
      @@repo_json = Utils.static_json(file_name: params[:filename])
      json(empty_json)
    end

    post '/commits_json' do
      @@commits_json = Utils.static_json(file_name: params[:filename])
      json(empty_json)
    end

    post '/response' do
      @@forced_body = (params[:body].empty?) ? nil : params[:body]
      @@forced_status = (params[:status].empty?) ? nil : params[:status]
      @@forced_type = (params[:type].empty?) ? nil : params[:type]
      json(empty_json)
    end

    get '/requests' do
      requests = []

      @@requests.each do |request|
        requests << { fullpath: request.fullpath } unless request.fullpath == '/requests'
      end

      json(requests)
    end
  end
end
