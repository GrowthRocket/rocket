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
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(phone_number captcha))
  end

  def require_price_judgment_and_save(plan)
    if plan.price.nil?
      flash[:alert] = "请填写方案价格"
      render "new"
      return
    elsif plan.plan_goal.nil?
      flash[:alert] = "请填写方案人数"
      render "new"
      return
    end
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

  def check_geetest
    # in your controller action

    require "geetest_ruby_sdk"

    challenge = params[:geetest_challenge] || ""
    validate = params[:geetest_validate] || ""
    seccode = params[:geetest_seccode] || ""

    # 将私钥传入，要注册的
    sdk = GeetestSDK.new(ENV["GEE_TEST_KEY"])
    @geetest = true
    unless sdk.validate(challenge, validate, seccode)
      @geetest = false
    end
  end
end
