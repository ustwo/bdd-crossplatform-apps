require 'json'
require 'httparty'

require_relative 'bind'

module GitHubMockBackend
  # Ruby API to the mock server. Allows to retrieve and set values, responses, etc.
  # This API is typically used from the steps to force a given server response or retrieve a value
  # returned to the application.
  class API
    # Initialises internal variables of the mock server.
    # Call before and after every scenario to be sure there are no leftovers from previous tests.
    def self.init
      HTTParty.get(Bind.url + '/init')
    end

    # Sets a delay in seconds for all server responses.
    # @param delay [Integer] the delay in seconds
    def self.set_request_delay(delay:)
      HTTParty.post(Bind.url + '/request_delay', body: { delay: delay })
    end

    # Returns the latest JSON returned by the server at the ```/repos/:org/:repo``` end point.
    # @return [JSON]
    def self.get_repo_json
      response = HTTParty.get(Bind.url + '/repo_json')
      JSON.parse(response.body)
    end

    # Sets the JSON response for the ```/repos/:org/:repo``` end point.
    # @param file_name [String] Name of the JSON file to be returned
    def self.set_repo_json(file_name:)
      HTTParty.post(Bind.url + '/repo_json', body: { filename: file_name })
    end

    # Returns the latest JSON returned by the server at the ```/repos/:org/:repo/commits``` end point.
    # @return [JSON]
    def self.get_commits_json
      response = HTTParty.get(Bind.url + '/commits_json')
      JSON.parse(response.body)
    end

    # Sets the JSON response for the ```/repos/:org/:repo/commits``` end point.
    # @param file_name [String] Name of the JSON file to be returned
    def self.set_commits_json(file_name:)
      HTTParty.post(Bind.url + '/commits_json', body: { filename: file_name })
    end

    # Sets the body, status and content type for all server responses. Use ```nil``` to "clear" previously set values.
    # @param body [String] Body of the server response
    # @param status [Integer] Status of the server response (200, 404, 500, etc)
    # @param type [String] Content type of the server response ('text/plain', 'application/json', etc)
    def self.set_response(body: nil, status: nil, type: nil)
      HTTParty.post(Bind.url + '/response', body: { body: body, status: status, type: type })
    end

    # Returns a JSON array with objects that describe the requests made to the server.
    # @return [JSON] A JSON array of objects with this format: ```{fullpath: 'xxx'}``` where ```x``` is
    # the full path of the request made to the server.
    def self.get_requests
      response = HTTParty.get(Bind.url + '/requests')
      JSON.parse(response.body)
    end
  end
end
