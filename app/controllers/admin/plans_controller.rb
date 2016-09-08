class Admin::PlansController < AdminController
  before_action :find_plan_by_project, only:[:edit,:update,:destroy]
  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans.recent
    set_page_title_and_description("管理回报", nil)
  end

  def new
    @project = Project.find(params[:project_id])
    @plan = @project.plans.new
    set_page_title_and_description("新建项目回报", nil)
  end

  def create
    @project = Project.find(params[:project_id])
    @plan = @project.plans.new(plan_params)
    check_plan_valid_for_create
  end

  def edit
    set_page_title_and_description("编辑项目回报", nil)
  end

  def update
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
    @plan.destroy
    flash[:alert] = "您已成功删除该回报。"
    redirect_to :back
  end

  protected

  def find_plan_by_project
    @project = Project.find(params[:project_id])
    @plan = @project.plans.find(params[:id])
  end

  private

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal, :need_add)
  end
end
