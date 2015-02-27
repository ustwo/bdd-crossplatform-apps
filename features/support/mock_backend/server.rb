require 'json'
require 'grape'

require_relative 'utils'

module GitHubMockBackend
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
        @@repo_json = Utils.static_json('default_repo')
      else
        @@repo_json
      end
    end

    get '/repos/:org/:repo/commits' do
      if @@commits_json.nil?
        @@commits_json = Utils.static_json('default_commits')
      else
        @@commits_json
      end
    end

    get '/repos/:org/:repo/commits/:commit' do
      if @@commit_json.nil?
        @@commit_json = Utils.static_json('default_commit')
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
      @@repo_json = Utils.static_json(file_name)
      {}
    end

    post '/commits_json' do
      file_name = params[:filename]
      @@commits_json = Utils.static_json(file_name)
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
  end
end
