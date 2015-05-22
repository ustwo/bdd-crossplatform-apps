require 'json'
require 'grape'

require_relative 'utils'

module GitHubMockBackend
  # Web server implementing a subset of the GitHub API.
  # Mostly returns static JSON files store in ```responses/json```.
  # It has a 'backdoor' API that allows to force specific responses, error codes, etc., see API for more info.
  class Server < Grape::API
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
    end

    # Returns repo's commit JSON file.
    get '/repos/:org/:repo/commits' do
      if @@commits_json.nil?
        @@commits_json = Utils.static_json(file_name: 'default_commits')
      else
        @@commits_json
      end
    end

    # Returns a commit JSON file.
    get '/repos/:org/:repo/commits/:commit' do
      if @@commit_json.nil?
        @@commit_json = Utils.static_json(file_name: 'default_commit')
      else
        @@commit_json
      end
    end

    # NOT part of the official API, just a helper to know we are up and running.
    get '/' do
      content_type 'text/plain'
      body 'Hello World'
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
      {}
    end

    post '/request_delay' do
      @@request_delay = params[:delay].to_i
      {}
    end

    get '/repo_json' do
      @@repo_json
    end

    get '/commits_json' do
      @@commits_json
    end

    post '/repo_json' do
      @@repo_json = Utils.static_json(file_name: params[:filename])
      {}
    end

    post '/commits_json' do
      @@commits_json = Utils.static_json(file_name: params[:filename])
      {}
    end

    post '/response' do
      @@forced_body = (params[:body].empty?) ? nil : params[:body]
      @@forced_status = (params[:status].empty?) ? nil : params[:status]
      @@forced_type = (params[:type].empty?) ? nil : params[:type]
      {}
    end

    get '/requests' do
      requests = []

      @@requests.each do |request|
        requests << { fullpath: request.fullpath } unless request.fullpath == '/requests'
      end

      requests
    end
  end
end
