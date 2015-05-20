require 'nokogiri'
require_relative 'string_resource'

class AndroidStringResource < StringResource

  def initialize(file_content:)
    @xml = Nokogiri::XML(file_content)
  end

  def get(key:)
    element = @xml.xpath("/resources/string[@name='#{key}']")
    if element.size == 1
      element.text
    else
      nil
    end
  end
end