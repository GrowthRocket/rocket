module Admin::ProjectsHelper
  def render_project_status(project)
    if project.is_hidden
      content_tag(:span, "", style: "color:red", class: "fa fa-lock fa-lg")
      else
        content_tag(:span, "", style: "color:blue", class: "fa fa-rocket fa-lg")
      end
  end



  def render_project_backers_quantity(project)

  end

end
