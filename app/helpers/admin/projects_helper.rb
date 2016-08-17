module Admin::ProjectsHelper
  def render_project_status(project)
    if project.is_hidden
      content_tag(:label, "已下架")
    else
      content_tag(:label, "已发布")
    end
  end

  def render_project_backers_quantity(project)
    

  end

end
