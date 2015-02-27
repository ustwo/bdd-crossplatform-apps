require 'json'
require 'httparty'

require_relative 'bind'

module GitHubMockBackend

  class API
    
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

  end
end
