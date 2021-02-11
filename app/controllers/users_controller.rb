class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.friendly.find(params[:id])
  end

  def invite_form
  end

  def message_form
  end
end
