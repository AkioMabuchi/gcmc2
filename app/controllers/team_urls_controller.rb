class TeamUrlsController < ApplicationController
  def create
    team_url = TeamUrl.new(team_url_params)
    if team_url.save
      redirect_to team_urls_path(params[:permalink]), notice: "URLを追加しました"
    else
      redirect_to team_urls_path(params[:permalink])
    end
  end

  def update
    team_url = TeamUrl.find(params[:id])
    team_url.update(team_url_params)
    if team_url.save
      redirect_to team_urls_path(params[:permalink]), notice: "URLを更新しました"
    else
      redirect_to team_urls_path(params[:permalink])
    end
  end

  def destroy
    team_url = TeamUrl.find(params[:id])
    team_url.destroy!
    redirect_to team_urls_path(params[:permalink]), notice: "URLを削除しました"
  end

  private

  def team_url_params
    params.require(:team_url).permit(:team_id, :name, :url, :is_public)
  end
end
