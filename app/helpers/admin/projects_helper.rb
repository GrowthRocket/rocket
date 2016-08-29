module Admin::ProjectsHelper
  def render_project_status(project)
    case project.aasm_state
    when "project_created"
      content_tag(:span, "已创建", class: "label label-warning")
    when "verifying"
      content_tag(:span, "审核中", class: "label label-default")
    when "online"
      content_tag(:span, "已上线", class: "label label-success")
    when "unverified"
      content_tag(:span, "审核未通过", class: "label label-danger")
    when "offline"
      content_tag(:span, "已结束众筹", class: "label label-info")
    end
  end

  def render_project_backers_quantity(project)
  end

  def render_project_empty_warning
    content_tag :div, class: "text-center" do
      content_tag :span, "暂时还没有项目哦"
    end
  end
end
