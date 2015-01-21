class Ability
  include CanCan::Ability

  def initialize(user)
    anonymous = user.nil?
    user = User.new if anonymous

    # All users can access contacts
    can [:create, :read, :update, :delete], Contact

    # All users can access schools
    can [:create, :read, :update, :delete], School

  end
end
