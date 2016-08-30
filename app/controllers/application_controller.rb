class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_sign_up_params, if: :devise_controller?

  helper_method :resource, :resource_name, :devise_mapping

     def resource_name
       :user
      end

     def resource
       @resource ||= User.new
     end

     def devise_mapping
       @devise_mapping ||= Devise.mappings[:user]
     end

  def require_is_admin
    unless current_user.admin?
      flash[:alert] = "You are not admin"
      redirect_to root_path
    end
  end


  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(attribute))
  end

  def require_create_plan_judgment(plan)
    if plan.price.nil?
      flash[:alert] = "请填写回报价格"
      render :new
      return
    elsif plan.plan_goal.nil?
      plan.plan_goal = 999
      # flash[:alert] = "请填写回报人数"
      # render :new
      # return
    end
    if plan.price > plan.project.fund_goal
      flash[:alert] = "回报价格不能大于项目筹款目标哦！"
      render :new
    else
      if plan.save
        flash[:notice] = "您已成功新建筹款回报。"
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


  def require_update_plan_judgment(plan, plan_params)
    if plan.price.nil?
      flash[:alert] = "请填写回报价格"
      render :edit
      return
    elsif plan.plan_goal.nil?
      flash[:alert] = "请填写回报人数"
      render :edit
      return
    elsif plan.plan_goal < plan.plan_progress
      flash[:alert] = "回报数量不可小于已支持人数"
      render :edit
      return
    end
    if plan.price > plan.project.fund_goal
      flash[:alert] = "回报价格不能大于项目筹款目标哦！"
      render :edit
      return
    else
      if plan.update(plan_params)
        flash[:notice] = "您已成功新建筹款回报。"
        if current_user.is_admin?
          redirect_to admin_project_plans_path
        else
          redirect_to account_project_plans_path
        end
      else
        render :edit
      end
    end
  end



  def check_geetest
    challenge = params[:geetest_challenge] || ""
    validate = params[:geetest_validate] || ""
    seccode = params[:geetest_seccode] || ""

    # 将私钥传入，要注册的
    sdk = GeetestSDK.new
    @geetest = true
    unless sdk.validate(challenge, validate, seccode)
      @geetest = false
    end
  end
end
