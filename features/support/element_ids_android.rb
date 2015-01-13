class ElementIdsAndroid

  def self.ids

    map = Hash.new
    map[:commitlist_header_title] = 'com.ustwo.sample:id/header_title'

    map[:commitlist_button_refresh] = 'com.ustwo.sample:id/commitlist_button_refresh'
    map[:commitlist_list_row_label_author] = 'com.ustwo.sample:id/commitlist_list_row_label_author'

    return map
  end
end
