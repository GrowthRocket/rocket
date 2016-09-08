class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_sign_up_params, if: :devise_controller?

  helper_method :resource, :resource_name, :devise_mapping

  rescue_from CanCan::AccessDenied do |exception|
    puts "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to main_app.root_url, :alert => exception.message
  end

  def set_page_title_and_description(title, description)
    unless title.blank?
      set_page_title title
    end
    unless description.blank?
      set_page_description description
    end
  end

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

  def check_plan_valid_for_create
    if @plan.price.blank?
      flash[:alert] = "请填写回报价格"
      render :new
    end
    if @plan.price.to_i > @project.fund_goal.to_i
      flash[:alert] = "回报价格不能大于项目筹款目标哦！"
      render :new
    else

      if @plan.save
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

  def check_plan_valid_for_edit
    if @plan.price.blank?
      flash[:alert] = "请填写回报价格"
      render :edit
      return
    end

    if @plan.plan_goal.blank?
      flash[:alert] = "请填写回报人数"
      render :edit
      return
    end

    if @plan.plan_goal.to_i < @plan.plan_progress.to_i
      flash[:alert] = "回报数量不可小于已支持人数"
      render :edit
      return
    end

    if @plan.price > @project.fund_goal.to_i
      flash[:alert] = "回报价格不能大于项目筹款目标哦！"
      render :edit
      return
    end

    if @plan.update(plan_params)
      flash[:notice] = "回报更新成功。"
      if current_user.is_admin?
        redirect_to admin_project_plans_path
      else
        redirect_to account_project_plans_path
      end
    else
      render :edit
    end
  end

  def check_geetest
    challenge = params[:geetest_challenge]
    validate = params[:geetest_validate]
    seccode = params[:geetest_seccode]

    # 将私钥传入，要注册的
    sdk = GeetestSDK.new
    @geetest = true
    unless sdk.validate(challenge, validate, seccode)
      @geetest = false
    end
  end
end
