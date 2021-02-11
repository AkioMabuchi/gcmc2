class TeamsController < ApplicationController
  def index
    @users = User.all
  end

  def show

  end

  def new
  end

  def edit
  end

  def create
    team = Team.new(team_params)
    if team.save
      redirect_to root_path, notice: "チームを作成しました"
    else
      redirect_to new_team_path
    end
  end

  def update

  end

  def destroy

  end

  private

  def team_params
    params.require(:team).permit(:owner_user_id, :permalink, :name, :image, :title, :description)
  end
end
