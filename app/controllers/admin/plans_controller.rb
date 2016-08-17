class Admin::PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout 'admin'

  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans
  end


  def new
    @project = Project.find(params[:project_id])
    @plan = Plan.new
    @savetype = 1

  end

  def create
    @project = Project.find(params[:project_id])
    @plan = Plan.new(plan_params)
    @plan.project = @project
    if @plan.save
      redirect_to admin_project_plans_path, notice: "您已成功新建筹款方案。"
    else
      @savetype = 1
      render :new
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @plan = Plan.find(params[:id])
    @savetype = 2

  end

  def update
    @project = Project.find(params[:project_id])

    @plan = Plan.find(params[:id])
    if @plan.update(plan_params)
      redirect_to admin_project_plans_path, notice: "您已成功更新筹款方案。"
    else
      render :edit
    end
  end

  def destroy

    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to :back, alert: "筹款方案删除成功"
  end


  private

  def plan_params
    params.require(:plan).permit(:title, :description, :price, :plan_goal)
  end

end
