class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.friendly.find(params[:id])
  end

  def new
  end

  def edit
    @team = Team.friendly.find(params[:id])
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
    team = Team.friendly.find(params[:id])
    team.update team_params
    if team.save
      redirect_to edit_team_path(params[:id]), notice: "チーム情報を更新しました"
    else
      redirect_to edit_team_path(params[:id])
    end
  end

  def destroy

  end

  def tags_edit
    @team = Team.friendly.find(params[:id])
  end

  def tags_update
    team = Team.friendly.find(params[:id])
    team.update team_tags_params
    if team.save
      redirect_to tags_edit_team_path(params[:id]), notice: "タグを更新しました"
    else
      redirect_to tags_edit_team_path(params[:id])
    end
  end

  def environments_edit
    @team = Team.friendly.find(params[:id])
  end

  def environments_update

  end

  def wants_edit
    @team = Team.friendly.find(params[:id])

    @react_info = {
        authenticityToken: form_authenticity_token,
        positions: PositionName.order(sort_number: :asc).select(:id, :name),
        team: {
            id: @team.id,
            permalink: @team.permalink
        },
        wantedPositions: @team.wanted_positions.joins(:position_name).order(sort_number: :asc).select(:id, :amount, :name_id, :name)
    }
  end

  def publishing_edit
    @team = Team.friendly.find(params[:id])
  end

  def publishing_update

  end

  def dissolution
    @team = Team.friendly.find(params[:id])
  end

  private

  def team_params
    params.require(:team).permit(:owner_user_id, :permalink, :name, :image, :title, :description)
  end

  def team_tags_params
    params.require(:team).permit(team_tag_name_ids: [])
  end
end
