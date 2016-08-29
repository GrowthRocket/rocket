class Admin::PlansController < AdminController
  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans.recent
  end

  def new
    @project = Project.find(params[:project_id])
    @plan = Plan.new
  end

  def create
    @project = Project.find(params[:project_id])
    @plan = Plan.new(plan_params)
    @plan.project = @project

    check_plan_valid_for_create

    if @plan.save
      redirect_to admin_project_plans_path
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @plan = Plan.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @plan = Plan.find(params[:id])

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

  private

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal)
  end
end
