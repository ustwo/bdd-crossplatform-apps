require 'json'

module GitHubMockBackend

  class Utils
    
    def self.file_content(file_name)
      File.read("#{File.dirname(__FILE__)}/responses/json/#{file_name}.json")
    end

    def self.static_json(file_name)
      JSON.parse(file_content(file_name))
    end
  end

end
