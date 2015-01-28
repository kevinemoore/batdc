class UsersController < ApplicationController
  load_and_authorize_resource except: [:create]

  respond_to :html

  def index
    @users = User.all.order(:created_at).includes(:roles)
  end


  def create
    @user = User.create(user_params)
    redirect_to @user
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def authorize
    auth_role = Role.find_by_name(:authorized)
    @user.roles << auth_role unless @user.roles.include? auth_role
    @user.save!
    redirect_to :users
  end

  private

  def permitted_params
    params.require(:user).permit(:email, :role)
  end

end
