class TeamsController < ApplicationController
  before_action :authenticate_user, only: [
    :edit,
    :update,
    :destroy,
    :tags_edit,
    :tags_update,
    :environments_edit,
    :environments_update,
    :wants_edit,
    :dissolution
  ]

  before_action :set_positions, only: [:index]

  def index
    @q = Team.ransack(params[:q])
    @teams = @q.result.includes(:team_tag_names).hyper_sort(current_user).page(params[:page]).per(5)
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
      if team.errors.messages[:permalink]
        flash[:permalink_warning] = team.errors.messages[:permalink][0]
      end
      if team.errors.messages[:name]
        flash[:name_warning] = team.errors.messages[:name][0]
      end
      if team.errors.messages[:title]
        flash[:title_warning] = team.errors.messages[:title][0]
      end
      if team.errors.messages[:not_adult]
        flash[:not_adult_warning] = team.errors.messages[:not_adult][0]
      end
      redirect_to new_team_path
    end
  end

  def update
    team = Team.friendly.find(params[:id])
    team.update team_params
    if team.save
      redirect_to edit_team_path(params[:id]), notice: "チーム情報を更新しました"
    else
      if team.errors.messages[:permalink]
        flash[:permalink_warning] = team.errors.messages[:permalink][0]
      end
      if team.errors.messages[:name]
        flash[:name_warning] = team.errors.messages[:name][0]
      end
      if team.errors.messages[:title]
        flash[:title_warning] = team.errors.messages[:title][0]
      end
      redirect_to edit_team_path(params[:id])
    end
  end

  def destroy
    team = Team.friendly.find(params[:id])
    team.destroy!

    redirect_to root_path, notice: "チームを解散させました"
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
    team = Team.friendly.find(params[:id])
    team.update team_environments_params
    if team.save
      redirect_to environments_edit_team_path(params[:id]), notice: "開発環境を更新しました"
    else
      redirect_to environments_edit_team_path(params[:id])
    end
  end

  def urls_edit
    @team = Team.friendly.find(params[:id])

    @react_info = {
      authenticityToken: form_authenticity_token,
      team: {
        id: @team.id,
        permalink: @team.permalink,
        urls: @team.team_urls
      },
      warnings:{
        name: flash[:name_warning],
        url: flash[:url_warning]
      }
    }
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

  def dissolution
    @team = Team.friendly.find(params[:id])
  end

  private

  def login_user_only
    unless user_signed_in?
      raise Forbidden
    end
  end

  def authenticate_user
    team = Team.friendly.find(params[:id])
    if user_signed_in?
      unless team.owner_user_id == current_user.id
        raise Forbidden
      end
    else
      raise Forbidden
    end
  end

  def set_positions
    positions = Set.new
    if user_signed_in?
      current_user.position_names.pluck(:id).each do |position|
        positions.add position
      end
    end

    Thread.current[:teams_hyper_sort] = positions
  end

  def team_params
    params.require(:team).permit(:owner_user_id, :permalink, :name, :image, :title, :description, :not_adult)
  end

  def team_tags_params
    params.require(:team).permit(team_tag_name_ids: [])
  end

  def team_environments_params
    params.require(:team).permit(:using_language, :platform, :source_tool, :communication_tool, :project_tool, :period, :frequency, :location)
  end
end
