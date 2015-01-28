class Ability
  include CanCan::Ability

  def initialize(user)
    anonymous = user.nil?
    user = User.new if anonymous

    if user.role? :admin
      can :manage, :all
    elsif user.role? :authorized
      # Approved users can access contacts
      can [:create, :read, :update, :delete], Contact
      
      # Approved users can access schools
      can [:create, :read, :update, :delete], School
      
      # Approved users can access events
      can [:create, :read, :update, :delete], Event
    end
  end
end
