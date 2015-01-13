require_relative 'element_id'

class ElementIdMap
  def self.map
    map = Hash.new
    map[:commitlist_button_refresh] = ElementId.new('R.id.commitlist_button_refresh',
      'commitlist_button_refresh',
      'commitlist_button_refresh')
    map[:commitlist_list_row_label_author] = ElementId.new('R.id.commitlist_list_row_label_author',
      'commitlist_list_row_label_author',
      'commitlist_list_row_label_author')

    return map
  end
end
