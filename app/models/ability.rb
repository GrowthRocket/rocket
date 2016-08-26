class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      # not logged in

      cannot :manage, :all
      basic_read_only
      basic_management
    elsif user.admin?
      # admin

      can :manage, :all
    else
      basic_read_only
      basic_management
    end
  end

  protected

  def basic_read_only
    can :read,    Project
    can :list,    Project
    can :search,  Project
  end

  def basic_management
    can :manage, Project
  end
end
