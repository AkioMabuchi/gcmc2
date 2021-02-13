class UsersController < ApplicationController
  def index
    positions = Set.new
    if user_signed_in?
      current_user.owner_teams.each do |team|
        team.position_names.each do |position|
          positions.add position.id
        end
      end
    end

    Thread.current[:users_hyper_sort] = positions
    @users = User.hyper_sort(current_user).page(params[:page]).per(10)
  end

  def show
    @user = User.friendly.find(params[:id])
  end

  def invite_form
  end

  def message_form
  end
end
