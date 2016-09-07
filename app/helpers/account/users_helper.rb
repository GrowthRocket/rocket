module Account::UsersHelper
  def render_user_center_sidebar
    if current_user.is_admin?
      render partial:"layouts/user_center_sidebar_for_admin"
    else
      render partial: "layouts/user_center_sidebar_for_user"
    end
  end
end
