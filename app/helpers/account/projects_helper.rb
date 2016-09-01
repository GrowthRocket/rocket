module Account::ProjectsHelper
  def render_project_video_or_image(project)
    if project.video && project.video.include?("youku")
      project.video.html_safe
    else
      image_tag(project.image.large)
   end
  end

  def render_project_operation(project)
    if project.project_created?
      link_to("编辑项目", edit_account_project_path(project), class: "btn btn-sm btn-default")
      link_to("申请上线", apply_for_verification_account_project_path(project), method:  :post,  class: "btn btn-sm btn-default")
      # link_to("管理回报", account_project_plans_path(project), class:"btn btn-sm btn-default")
    elsif project.verifying?
      link_to("申请上线", apply_for_verification_account_project_path(project), method:  :post,  class: "btn btn-sm btn-default")
      # link_to("管理回报", account_project_plans_path(project), class:"btn btn-sm btn-default")
    elsif project.online?
      # link_to("管理回报", account_project_plans_path(project), class:"btn btn-sm btn-default")
      link_to("管理动态", account_project_posts_path(project), class:"btn btn-sm btn-default")
      link_to("结束众筹", offline_account_project_path(project), method: :post, class: "btn btn-sm btn-default", data: { confirm: "结束众筹后项目将下线，操作不可恢复，你确定结束么？" })
    elsif project.unverified?
      link_to("查看审核详情", reject_message_account_project_path(project), method: :post, class: "btn btn-sm btn-default")
      link_to("编辑项目", edit_account_project_path(project), class: "btn btn-sm btn-default")
      link_to("申请上线", apply_for_verification_account_project_path(project), method: :post,  class: "btn btn-sm btn-default")
      # link_to("管理回报", account_project_plans_path(project), class:"btn btn-sm btn-default")
    elsif project.offline?
      link_to("管理动态", account_project_posts_path(project), class:"btn btn-sm btn-default")
      # link_to("管理回报", account_project_plans_path(project), class:"btn btn-sm btn-default")
    end
  end

    # TODO controller里需要对project不同状态进行判断，不同状态下操作不同。



  def render_project_empty_warning
    content_tag :div, class: "text-center" do
      content_tag :span, "您暂时还没有项目哦，请创建"
    end
  end
end
