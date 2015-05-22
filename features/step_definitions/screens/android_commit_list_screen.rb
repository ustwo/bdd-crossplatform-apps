require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen
  def get_title
    # Get the ActionBar text - assume its the first TextView in the view hierarchy
    @driver.find_element(class: 'android.widget.TextView').name
  end

  def get_commit(index)
    text = @driver.find_elements(id: 'com.ustwo.sample:id/commit_list_row_textview_message')[index].text
    date = @driver.find_elements(id: 'com.ustwo.sample:id/commit_list_row_textview_date')[index].text

    { text: text, date: date }
  end

  def ids
    {
      # Commit List Screen
      commitlist_button_refresh: 'com.ustwo.sample:id/commit_list_button_refresh',
      commitlist_no_commits_indicator: 'com.ustwo.sample:id/commit_list_textview_status_information',
      commitlist_loading_indicator: 'android:id/progress',

      # Commit List Row
      commitlist_list_row: 'com.ustwo.sample:id/commit_list_linearlayout_row',
      commitlist_row_textview_date: 'com.ustwo.sample:id/commit_list_row_textview_date',
      commitlist_row_textview_message: 'com.ustwo.sample:id/commit_list_row_textview_message',
      commitlist_list: 'com.ustwo.sample:id/commit_list_listview_commits'
    }
  end
end
