class Ability
  include CanCan::Ability

  def initialize(user)
    anonymous = user.nil?
    user = User.new if anonymous

    # All users can read all tables.
    can :read, DbTable

    unless anonymous
      # All registered users can create tables.
      can :create, DbTable
      # Users can only modify tables that belong to them.
      can [:update, :destroy, :import_csv, :upload_csv], DbTable,
          user_id: user.id
      can [:new, :create, :delete, :destroy], DbRow,
          user_id: user.id
    end
  end
end
