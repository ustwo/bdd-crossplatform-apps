require_relative 'commit_detail_screen'

class AndroidCommitDetailScreen < CommitDetailScreen
  def ids
    {
      commit_detail_root: 'com.ustwo.sample:id/commit_detail_linearlayout_root',
      commit_detail_loading_indicator: 'android:id/progress',
      commit_detail_textview_name: 'com.ustwo.sample:id/commit_detail_textview_name',
      commit_detail_textview_email: 'com.ustwo.sample:id/commit_detail_textview_email',
      commit_detail_textview_date: 'com.ustwo.sample:id/commit_detail_textview_date',
      commit_detail_textview_message: 'com.ustwo.sample:id/commit_detail_textview_message'
    }
  end
end
