class Account::PlansController < AccountController
  before_action :find_project
  authorize_resource

  def index
    @plans = @project.plans.normal.recent
    set_page_title_and_description("管理回报", view_context.truncate(@project.name, :length => 100))
  end

  def new
    @plan = @project.plans.build
    set_page_title_and_description("新建回报", view_context.truncate(@project.name, :length => 100))
  end

  def create_plan
    if find_plan.nil?
      @plan = @project.plans.build(plan_params)
      message = verifyPlan(@plan)
      if message[:status] == "y"
        if @plan.save
          message[:plan_id] = @plan.id
          render json: message
        else
          errors = @plan.errors
          message[:status] = "e"
          message[:errors] = errors
          render json: message
        end
      else
        render json: message
      end
    else
      @plan = find_plan
      @plan_new = @project.plans.build(plan_params)
      message = verifyPlan(@plan_new)
      if message[:status] == "y"
        if @plan.update(plan_params)
          message[:status] = "r"
          render json: message
        else
          @errors = @plan.errors
          message[:status] = "e"
          message[:errors] = errors
          render json: message
        end
      else
        render json: message
      end
    end
  end

  def get_plans
    @plans = @project.plans.normal
    render json: @plans
  end

  def create
    @plan = @project.plans.build(plan_params)
    check_plan_valid_for_create
  end

  def edit
    @plan = @project.plans.normal.find(params[:id])
    set_page_title_and_description("修改回报", view_context.truncate(@project.name, :length => 100))
    authorize! :update, @plan
    # update
  end

  def update
    @plan = @project.plans.find(params[:id])
    check_plan_valid_for_edit
    # binding.pry
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

  def destroy
    @plan = current_user.projects.find(@project).plans.find(params[:id]);
    @plan.destroy
    flash[:alert] = "您已成功删除该回报。"
    redirect_to :back
  end

  private

  def verifyPlan(plan)
    info = {}
    if plan.price.nil?
      info[:status] = "customerror"
      info[:message] = "请填写方案价格"
      return info
    elsif plan.plan_goal.nil?
      plan.plan_goal = 999
    end
    if plan.price > plan.project.fund_goal
      info[:status] = "customerror"
      info[:message] = "方案价格不能大于项目筹款目标哦！"
      return info
    else
      info[:status] = "y"
      return info
    end
  end

  def find_plan
    plan = @project.plans.find_by(id: params[:plan_id])
  end

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal, :need_add)
  end
end
