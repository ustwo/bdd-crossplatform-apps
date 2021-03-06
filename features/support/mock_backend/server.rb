 # 
 # The MIT License (MIT)
 # 
 # Copyright (c) 2015 ustwo™
 # 
 # Permission is hereby granted, free of charge, to any person obtaining a copy
 # of this software and associated documentation files (the "Software"), to deal
 # in the Software without restriction, including without limitation the rights
 # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 # copies of the Software, and to permit persons to whom the Software is
 # furnished to do so, subject to the following conditions:

 # The above copyright notice and this permission notice shall be included in all
 # copies or substantial portions of the Software.
 # 
 # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 # SOFTWARE.

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

      def backdoor_api fullpath
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
      if backdoor_api(request.fullpath)
        return
      end

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
        halt @@forced_body
      end

      if !@@error_json.nil?
        error!(@@error_json)
      end
    end

    # Returns repo JSON file.
    get '/repos/:org/:repo' do
      if @@repo_json.nil?
        @@repo_json = Utils.static_json(file_name: 'default_repo')
      else
        @@repo_json
      end

      json @@repo_json
    end

    # Returns repo's commit JSON file.
    get '/repos/:org/:repo/commits' do
      if @@commits_json.nil?
        @@commits_json = Utils.static_json(file_name: 'default_commits')
      else
        @@commits_json
      end

      json @@commits_json
    end

    # Returns a commit JSON file.
    get '/repos/:org/:repo/commits/:commit' do
      if @@commit_json.nil?
        @@commit_json = Utils.static_json(file_name: 'default_commit')
      else
        @@commit_json
      end

      json @@commit_json
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
      json empty_json
    end

    post '/request_delay' do
      delay = params[:delay].to_i
      @@request_delay = delay
      json empty_json
    end

    get '/repo_json' do
      json @@repo_json
    end

    get '/commits_json' do
      json @@commits_json
    end

    post '/repo_json' do
      file_name = params[:filename]
      @@repo_json = Utils.static_json(file_name: file_name)
      json empty_json
    end

    post '/commits_json' do
      file_name = params[:filename]
      @@commits_json = Utils.static_json(file_name: file_name)
      json empty_json
    end

    post '/response' do
      @@forced_body = (params[:body].empty?)? nil : params[:body]
      @@forced_status = (params[:status].empty?)? nil : params[:status]
      @@forced_type = (params[:type].empty?)? nil : params[:type]
      json empty_json
    end

    get '/requests' do
      requests = []

      @@requests.each do |request|
        requests << {fullpath: request.fullpath} unless request.fullpath == '/requests'
      end

      json requests
    end
  end
end
