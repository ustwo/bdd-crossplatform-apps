class ElementId
  attr_accessor :android
  attr_accessor :ios
  attr_accessor :web

  def initialize(android, ios, web)
      @android = android
      @ios = ios
      @web = web
   end
end