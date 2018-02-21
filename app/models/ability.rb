class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :confirm_email, :all
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote]
    can %i[update destroy], [Question, Answer, Comment], user: user
    can :assign_best, Answer, question: { user: user }
    can :manage, Attach, attachable: { user: user }
  end

  def admin_abilities
    can :manage, :all
  end
end
