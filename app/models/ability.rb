class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
      # basic_management
    elsif user.admin?
      # admin
      can :manage, :all
    else
       basic_read_only
      # basic_management
      user_project_management
      user_plan_management(user)
      user_post_management
      cannot :read, User
      # user_order_management
    end
  end

  protected

  # :manage: 是指這個 controller 內所有的 action
  # :read : 指 :index 和 :show
  # :update: 指 :edit 和 :update
  # :destroy: 指 :destroy
  # :create: 指 :new 和 :crate
  # all 是指所有 object (resource)

  def user_project_management

    # can :read, Project
    can :search,  Project
    can :create, Project
    can :demo, Project
    can %i(edit update), Project do |project|
      (project.project_created? || project.unverified?)
    end

    can :apply_for_verification, Project do |project|
      (project.project_created? || project.unverified?)
    end
    can :apply_for_verification_new, Project do |project|
      (project.project_created? || project.unverified?)
    end

    can :reject_message, Project do |project|
      project.unverified?
    end

    can :offline, Project do |project|
      project.online?
    end

    can :preview, Project do |project|
      project.project_created? || project.verifying? || project.unverified?
    end

    can :destroy, Project do |project|
      project.project_created?
    end

  end

  def user_plan_management(user)
    can :create, Plan
    can :show, Plan
    can :update, Plan
    can :get_plans, Plan
    can :create_plan, Plan
    can :destroy, Plan
  end

  def user_post_management
    can :read, Post

    can :create, Post

    can :destroy, Post
  end

  # TODO: 增加对下单对判断
  def user_order_management
    can :create, Plan
  end


  def basic_read_only
    can :read, Project, aasm_state: "online"
    can :read, Project, aasm_state: "offline"
    can :read, Plan, :project => {aasm_state: "online" }
    can :read, Plan, :project => {aasm_state: "offline" }
    # can :list,    Project
    can :search,  Project
  end

  def basic_management
    can :manage, Project
    can :manage, Plan do |plan|
      (plan.project.user_id == user.id)
    end
    can :manage, Post do |post|
      (post.project.user_id == post.id)
    end
  end
end
