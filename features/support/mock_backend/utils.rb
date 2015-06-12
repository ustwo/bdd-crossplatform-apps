/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 ustwo™
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

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
