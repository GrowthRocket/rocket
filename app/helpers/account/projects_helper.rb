module Account::ProjectsHelper
  def render_project_operation(project)
    if project.aasm_state == "project_created" && @projects.where("aasm_state = ? OR aasm_state = ?", "online", "verifying").count == 0
      link_to("申请发布", apply_for_verification_account_project_path(project), :method => :post,  :class => "btn btn-xs btn-info")
    elsif project.aasm_state == "online"
      link_to("下线", offline_account_project_path(project), :method => :post,  :class => "btn btn-xs btn-info")
    elsif project.aasm_state == "unverified"
      # link_to("查看审核详情", check_info_account_project_path(project), :method => :post,  :class => "btn btn-xs btn-info")
      link_to("申请发布", apply_for_verification_account_project_path(project), :method => :post,  :class => "btn btn-xs btn-info")
    else
      ""
    end
  end

end
