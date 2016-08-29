class Account::PlansController < AccountController
  before_action :find_project
  authorize_resource

  def index
    @plans = @project.plans.normal.recent
  end

  def new
    @plan = @project.plans.build
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
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal)
  end
end
