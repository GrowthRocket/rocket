class Admin::PlansController < ApplicationController
  # before_action :authenticate_user!
  # before_action :require_is_admin
  layout 'admin'

  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans
  end

  def show
    @project = Project.find(params[:project_id])
    @plan = Plan.find(params[:id])
  end

  def new
    @project = Project.find(params[:project_id])

    @plan = Plan.new

  end

  def create
    @project = Project.find(params[:project_id])
    @plan = Plan.new(plan_params)
    @plan.project = @project
    if @plan.save
      redirect_to admin_project_plans_path, notice: "筹款方案新建成功"
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
    if @plan.update(plan_params)
      redirect_to admin_project_plans_path, notice: "筹款方案更新成功"
    else
      render :edit
    end
  end

  def destroy
    # @project = Project.find(params[:project_id])

    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to :back, alert: "筹款方案删除成功"
  end


  private

  def plan_params
    params.require(:plan).permit(:title, :description, :price)
  end

end
