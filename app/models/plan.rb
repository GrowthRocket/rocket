
class Plan < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :plan_goal, presence: true
  validates :plan_goal, numericality: { greater_than: 0, less_than: 1_000_000 }
  belongs_to :project, counter_cache: true
  has_many :orders
end

def require_price_judgment_and_save(plan)
  if plan.price < plan.project.fund_goal
    if plan.save
      flash[:notice] = "您已成功新建筹款方案。"
      redirect_to admin_project_plans_path
    else
      render :new
    end
  else
    flash[:alert] = "方案价格应当小于项目筹款目标哦！"
    render :new
  end
end

# == Schema Information
#
# Table name: plans
#
#  id              :integer          not null, primary key
#  title           :string
#  description     :text
#  quantity        :integer          default(1)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  price           :integer
#  project_id      :integer
#  plan_goal       :integer
#  plan_progress   :integer          default(0)
#  backer_quantity :integer          default(0)
#
