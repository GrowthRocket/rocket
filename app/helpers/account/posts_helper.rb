module Account::PostsHelper
  def render_post_description(post)
    truncate(simple_format(post.description), escape: false, length: 20)
  end
end
