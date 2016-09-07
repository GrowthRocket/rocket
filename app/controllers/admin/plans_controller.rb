class Admin::PlansController < AdminController
  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans.recent
    set_page_title_and_description("管理回报", nil)
  end

  def new
    @project = Project.find(params[:project_id])
    @plan = Plan.new
    set_page_title_and_description("新建项目回报", nil)
  end

  def create
    @project = Project.find(params[:project_id])
    @plan = Plan.new(plan_params)
    @plan.project = @project

    check_plan_valid_for_create
  end

  def edit
    @project = Project.find(params[:project_id])
    @plan = Plan.find(params[:id])
    set_page_title_and_description("编辑项目回报", nil)
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

  def destroy
    @plan = Project.find(params[:project_id]).plans.find(params[:id])
    @plan.destroy
    flash[:alert] = "您已成功删除该回报。"
    redirect_to :back
  end

  private

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal, :need_add)
  end
end
