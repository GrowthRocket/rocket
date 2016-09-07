module Account::ProjectsHelper
  def render_project_video_or_image(project)
    if project.video && project.video.include?("youku")
      project.video.html_safe
    else
      image_tag(project.image.large)
    end
  end

  def render_project_operation(project)
    case project.aasm_state
    when 'project_created'
      render partial: "account/projects/render_project_created", locals: { project: project }
    when 'verifying'
      render partial: "account/projects/render_project_verifying", locals: { project: project }
    when 'online'
      render partial: "account/projects/render_online", locals: { project: project }
    when 'unverified'
      render partial: "account/projects/render_unverified", locals: { project: project }
    when 'offline'
      render partial: "account/projects/render_project_offline", locals: { project: project }
      # link_to("管理动态", account_project_posts_path(project), class:"btn btn-sm btn-default")
      # link_to("管理回报", account_project_plans_path(project), class:"btn btn-sm btn-default")
    end
  end

    # TODO controller里需要对project不同状态进行判断，不同状态下操作不同。



  def render_project_empty_warning
    content_tag :div, class: "text-center" do
      content_tag :span, "您暂时还没有创建项目哦，请点击“发起众筹”开始创建一个新的项目。"
    end
  end
end
