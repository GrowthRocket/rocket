module ApplicationHelper
  def render_order_created_at(create_at)
    create_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def render_project_created_at(create_at)
    create_at.strftime("%Y-%m-%d")
  end
end
