class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    user_id = user.id

    can :manage, Project, user_id: user_id
    can :manage, Task, project: { user_id: user_id }
    can :manage, Forecast, task: { project: { user_id: user_id } }
  end
end
