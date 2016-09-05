class Account::PlansController < AccountController
  before_action :find_project
  authorize_resource

  def index
    @plans = @project.plans.normal.recent
  end

  def new
    @plan = @project.plans.build
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

    if @plan.save
      redirect_to account_project_plans_path
    else
      render :new
    end
  end

  def edit
    @plan = @project.plans.normal.find(params[:id])
  end

  def update
    @plan = @project.plans.find(params[:id])
    check_plan_valid_for_edit

    if @plan.update(plan_params)
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

  def destroy
    @plan = Plan.find(params[:id]);
    @plan.destroy
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
    @project = Project.find(params[:project_id])
  end

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal)
  end
end
