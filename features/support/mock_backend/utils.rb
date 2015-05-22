require 'json'

module GitHubMockBackend
  # Utility class
  class Utils
    # Returns the content of a JSON file in the responses folder.
    # @param file_name [String] Name of the JSON file to read
    # @return [String] The contents of the JSON file
    def self.file_content(file_name:)
      File.read("#{File.dirname(__FILE__)}/responses/json/#{file_name}.json")
    end

    # Returns a JSON object from the
    # @param file_name [String] Name of the JSON file to read
    # @return [JSON] A parsed JSON object created from the contents of the static file
    def self.static_json(file_name:)
      JSON.parse(file_content(file_name: file_name))
    end
  end
end
