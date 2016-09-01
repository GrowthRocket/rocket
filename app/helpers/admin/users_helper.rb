module Admin::UsersHelper
  def render_user_status(user)
    case user.aasm_state
    when "user_registered"
      content_tag(:span, "已注册", class: "label label-success")
    when "request_verify"
      content_tag(:span, "请求实名认证", class: "label label-warning")
    when "unpassed_verified"
      content_tag(:span, "审核未通过", class: "label label-danger")
    when "passed_verified"
      content_tag(:span, "审核已通过", class: "label label-info")
    end
  end
end
