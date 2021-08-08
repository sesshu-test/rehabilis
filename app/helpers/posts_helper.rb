module PostsHelper
  def impression_with_hashtags(impression)
    impression.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| 
      link_to word, root_path(name: word.delete("#"), from_hashtag: true)
    }.html_safe
  end 
end
