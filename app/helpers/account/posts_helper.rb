module Account::PostsHelper
  def render_post_description(post)
    truncate(sanitize(post.description), escape: false, length: 20)
  end
end
