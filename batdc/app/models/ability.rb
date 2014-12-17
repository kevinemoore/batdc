class Ability
  include CanCan::Ability

  def initialize(user)
    anonymous = user.nil?
    user = User.new if anonymous

    # All users can read all tables.
    can [:create, :read, :update, :delete], Contact

  end
end
