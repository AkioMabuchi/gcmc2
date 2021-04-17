class UsersController < ApplicationController
  before_action :set_positions, only: [:index]
  def index
    @q = User.ransack(params[:q])
    @users = @q.result.includes(:user_tag_names).hyper_sort(current_user).page(params[:page]).per(10)
  end

  def show
    @user = User.friendly.find(params[:id])

    if user_signed_in?
      owner_teams = []
      current_user.owner_teams.each do |owner_team|
        team = {
            permalink: owner_team.permalink,
            id: owner_team.id,
            name: owner_team.name,
            positionIds: owner_team.position_names.pluck(:id)
        }
        owner_teams.append team
      end
      @react_info = {
          authenticityToken: form_authenticity_token,
          user:{
              id: @user.id,
              name: @user.name
          },
          teams: owner_teams,
          positions: @user.position_names.select(:id, :name)
      }
    end
  end

  private

  def set_positions
    positions = Set.new
    if user_signed_in?
      current_user.owner_teams.each do |team|
        team.position_names.each do |position|
          positions.add position.id
        end
      end
    end

    Thread.current[:users_hyper_sort] = positions
  end
end
