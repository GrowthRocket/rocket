class Ability
  include CanCan::Ability

  def initialize(user)
    # binding.pry
    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
      # basic_management
    elsif user.admin?
      # admin
      # can :manage, :all
      admin_project_management
      user_plan_management
      user_post_management(user)
    else
      #  basic_read_only
      # basic_management
      user_project_management
      user_plan_management
      user_post_management(user)
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

  def admin_project_management

    can :create, Project

    can :read, Project do |project|
      project.online? || project.offline?
    end
    can :search,  Project
    can %i(edit update), Project do |project|
      (project.project_created? || project.online? || project.unverified?)
    end

    can :publish, Project do |project|
      (project.project_created? || project.unverified?)
    end

    can :destroy, Project do |project|
      (project.project_created? || project.online? || project.verifying? || project.unverified?)
    end

    can :preview, Project do |project|
      project.project_created? || project.verifying? || project.unverified?
    end

    can :read, Project do |project|
      project.verifying?
    end

    can :offline, Project do |project|
      project.online?
    end
  end

  def user_project_management

    can :read, Project
    can :search,  Project
    can :create, Project
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

  end

  def user_plan_management
    can :create, Plan
    can :update, Plan do |plan|
      plan.project.online?
    end

    can :read, Plan do |plan|
      plan.project.online?
    end
    can :get_plans, Plan
    can :create_plan, Plan
    can :destroy, Plan
  end

  def user_post_management(user)
    can :read, Post do |post|
      (post.project.user_id == user.id && post.project.online?)
    end

    can :create, Post

    can :destroy, Post
  end

  # TODO: 增加对下单对判断
  def user_order_management
    can :create, Plan
  end


  def basic_read_only
    can :read,    Project
    can :list,    Project
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
