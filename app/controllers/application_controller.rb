class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_sign_up_params, if: :devise_controller?

  def require_is_admin
    unless current_user.admin?
      flash[:alert] = "You are not admin"
      redirect_to root_path
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute,:user_name,:phone_number, :captcha])
  end

  def require_price_judgment_and_save(plan)
    if plan.price > plan.project.fund_goal
      flash[:alert] = "方案价格不能大于项目筹款目标哦！"
      render :new
    else
      if plan.save
        flash[:notice] = "您已成功新建筹款方案。"
        if current_user.is_admin?
          redirect_to admin_project_plans_path
        else
          redirect_to account_project_plans_path
        end
      else
        render :new
      end
    end
  end
end
