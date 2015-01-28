class UsersController < ApplicationController

  load_and_authorize_resource

  respond_to :html

  def index
    @users = User.all.order(:created_at).includes(:roles)
  end

  private

  def permitted_params
    params.permit!
  end

end
