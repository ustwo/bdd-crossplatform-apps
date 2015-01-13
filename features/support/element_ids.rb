require_relative 'element_ids_android'
require_relative 'element_ids_ios'

class ElementIds

  def self.ids(platform)

    ids = nil
    if (platform == 'android')
      ids = ElementIdsAndroid.ids
    elsif (platform == 'ios')
      ids = ElementIdsIos.ids
    end

    return ids
  end
end
