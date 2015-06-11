require_relative 'commit_detail_screen'

class IosCommitDetailScreen < CommitDetailScreen
  
  def ids
    { commit_detail_root: 'commit_detail_view' }
  end

end