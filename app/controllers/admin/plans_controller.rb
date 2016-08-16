class Admin::PlansController < ApplicationController
  # before_action :authenticate_user!
  # before_action :require_is_admin
  layout 'admin'

  def index
    @plans = Plan.all
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to root_path, notice: "筹款方案新建成功"
    else
      render :new
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    if @plan.update(plan_params)
      redirect_to root_path, notice: "筹款方案更新成功"
    else
      render :edit
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to root_path, alert: "筹款方案删除成功"
  end


  private

  def plan_params
    params.require(:plan).permit(:title, :description, :price)
  end

end
