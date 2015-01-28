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

  private

  def permitted_params
    params.require(:user).permit(:email, :encrypted_password)
  end

end
