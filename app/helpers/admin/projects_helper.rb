module Admin::ProjectsHelper
  def render_project_status(project)
    if project.is_hidden
      content_tag(:span, "", style: "color:#E63C3C", class: "fa fa-lock fa-lg")
      else
        content_tag(:span, "", style: "color:#026EC0", class: "fa fa-rocket fa-lg")
      end
  end



  def render_project_backers_quantity(project)

  end

end
