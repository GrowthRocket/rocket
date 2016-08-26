# == Schema Information
#
# Table name: projects
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  user_id         :integer
#  image           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  fund_goal       :integer
#  fund_progress   :integer          default(0)
#  backer_quantity :integer          default(0)
#  plans_count     :integer          default(0)
#  category_id     :integer
#  aasm_state      :string           default("project_created")
#  video           :string
#
# Indexes
#
#  index_projects_on_aasm_state  (aasm_state)
#

require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
end
