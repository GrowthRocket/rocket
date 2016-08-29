module Account::ProjectsHelper
  def render_project_video_or_image(project)
    if project.video && project.video.include?("youku")
      project.video.html_safe
    else
      image_tag(project.image.large)
   end
  end

  def render_project_operation(project)
    if project.online?
      link_to("结束众筹", offline_account_project_path(project), :method => :post,  :class => "btn btn-sm btn-default")
      # if project.project_created? &&
      #    @projects.where("aasm_state = ? OR aasm_state = ?", "online", "verifying").count.zero? &&
      #    project.plans_count.nonzero?
      #   link_to("上线", apply_for_verification_account_project_path(project), method: :post, class: "btn btn-sm btn-info")
      # elsif project.online?
      #   link_to("结束众筹", offline_account_project_path(project), method: :post, class: "btn btn-sm btn-info")
    elsif project.unverified?
      link_to("查看审核详情", reject_message_account_project_path(project), method: :post, class: "btn btn-sm btn-default")
      # link_to("查看审核详情", "#", :method => :post,  :class => "btn btn-sm btn-info disabled")
    else
      ""
    end
  end

  def render_project_empty_warning
    content_tag :div, class: "text-center" do
      content_tag :span, "您暂时还没有项目哦，请创建"
    end
  end

end
