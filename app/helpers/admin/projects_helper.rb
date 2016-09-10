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
      content_tag :span, "您暂时还没有创建项目哦，请点击“发起众筹”开始创建一个新的项目。"
    end
  end

  def render_admin_project_operation(project)
    if project.project_created?
      render partial: "admin/projects/render_project_created", locals: { project: project }
    elsif project.verifying?
      render partial: "admin/projects/render_project_verifying", locals: { project: project }
    elsif project.online?
      render partial: "admin/projects/render_online", locals: { project: project }
    elsif project.unverified?
      render partial: "admin/projects/render_unverified", locals: { project: project }
    else
      link_to("删除", admin_project_path(project), :method => :delete, :data => { :confirm => "删除项目后不可恢复，您确定要删除吗?" }, :class => "btn btn-sm btn-default")
    end

  end
end
