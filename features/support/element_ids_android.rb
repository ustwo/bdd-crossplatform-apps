class ElementIdsAndroid

  def self.ids

    map = Hash.new

    # Commit List Screen
    map[:commitlist_button_refresh] = 'com.ustwo.sample:id/commit_list_button_refresh'
    map[:commitlist_no_commits_indicator] = 'com.ustwo.sample:id/commit_list_textview_status_information'

    # Commit List Row
    map[:commitlist_row_textview_date] = 'com.ustwo.sample:id/commit_list_row_textview_date'
    map[:commitlist_row_textview_message] = 'com.ustwo.sample:id/commit_list_row_textview_message'

	# Commit Detail Screen
    map[:commit_detail_textview_name] = 'com.ustwo.sample:id/commit_detail_textview_name'
	map[:commit_detail_textview_email] = 'com.ustwo.sample:id/commit_detail_textview_email'
	map[:commit_detail_textview_date] = 'com.ustwo.sample:id/commit_detail_textview_date'
	map[:commit_detail_textview_message] = 'com.ustwo.sample:id/commit_detail_textview_message'

    return map
  end
end
