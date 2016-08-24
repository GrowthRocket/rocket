module Account::ProjectsHelper
  def render_project_video_or_image(project)
    if project.video && project.video.include?("youku")
      project.video.html_safe
    else
      image_tag(project.image.large)
   end
  end

  def render_project_operation(project)
    if project.aasm_state == "online"
      link_to("下线", offline_account_project_path(project), :method => :post,  :class => "btn btn-xs btn-info")
    # if project.aasm_state == "project_created" &&
    #    @projects.where("aasm_state = ? OR aasm_state = ?", "online", "verifying").count.zero? &&
    #    project.plans_count.nonzero?
    #   link_to("上线", apply_for_verification_account_project_path(project), method: :post, class: "btn btn-xs btn-info")
    # elsif project.aasm_state == "online"
    #   link_to("下线", offline_account_project_path(project), method: :post, class: "btn btn-xs btn-info")
    elsif project.aasm_state == "unverified"
      link_to("查看审核详情", reject_message_account_project_path(project), method: :post, class: "btn btn-xs btn-info")
      # link_to("查看审核详情", "#", :method => :post,  :class => "btn btn-xs btn-info disabled")
    else
      ""
    end
  end

end
