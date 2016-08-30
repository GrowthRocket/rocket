class ProjectsController < ApplicationController
  before_action :validate_search_key, only: [:search]

  def index
    @projects =
      if params[:category_id]
        Project.where("category_id = ? AND aasm_state = ? OR aasm_state = ?", params[:category_id], "online", "offline")
      else
        Project.where("aasm_state = ? OR aasm_state = ?", "online", "offline")
                     end
    @categories = Category.all
  end

  def show
    @project = Project.find(params[:id])
    @user = @project.user
    @posts = @project.posts.recent
    @plans = @project.plans.price
  end

  def search
    if @query_string.present?
      search_result = Project.ransack(@search_criteria).result(distinct: true)
      @projects = search_result.paginate(page: params[:page], per_page: 20)
      # set_page_title "搜索 #{@query_string}"
    end
  end

  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end

  def search_criteria(query_string)
    { name_cont: query_string, aasm_state_eq: "online" }
  end
end
