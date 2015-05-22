require_relative 'commit_detail_screen'

class AndroidCommitDetailScreen < CommitDetailScreen
  def ids
    map = {}

    map[:commit_detail_root] = 'com.ustwo.sample:id/commit_detail_linearlayout_root'
    map[:commit_detail_loading_indicator] = 'android:id/progress'

    map[:commit_detail_textview_name] = 'com.ustwo.sample:id/commit_detail_textview_name'
    map[:commit_detail_textview_email] = 'com.ustwo.sample:id/commit_detail_textview_email'
    map[:commit_detail_textview_date] = 'com.ustwo.sample:id/commit_detail_textview_date'
    map[:commit_detail_textview_message] = 'com.ustwo.sample:id/commit_detail_textview_message'

    map
  end
end
