module Account::ProjectsHelper
  def render_project_operation(project)
    if project.aasm_state == "online"
      link_to("下线", offline_account_project_path(project), :method => :post,  :class => "btn btn-xs btn-info")
    elsif project.aasm_state == "unverified"
      link_to("查看审核详情", reject_message_account_project_path(project), :method => :post,  :class => "btn btn-xs btn-info")
      # link_to("查看审核详情", "#", :method => :post,  :class => "btn btn-xs btn-info disabled")
    else
      ""
    end
  end
end
