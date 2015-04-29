class Ability
  include CanCan::Ability

  def initialize(user)
    anonymous = user.nil?
    user = User.new if anonymous

    if user.role? :admin
      can :manage, :all
    elsif user.role? :authorized
      # Approved users can access contacts
      can [:create, :read, :update, :destroy, :email], Contact
      
      # Approved users can access schools
      can [:create, :read, :update, :destroy, :add_preferred,
      :add_membership, :del_membership], School
      
      # Approved users can access events
      can [:create, :read, :update, :destroy, :add_attendee, :email, :attendees], Event

      # Approved users can delete attendee records
      can [:destroy], Attendee
    end
  end
end
