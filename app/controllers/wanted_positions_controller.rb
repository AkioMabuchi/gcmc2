class WantedPositionsController < ApplicationController
  def create
    wanted_position = WantedPosition.new(wanted_position_params)
    if wanted_position.save
      redirect_to wants_edit_team_path(params[:permalink]), notice: "募集ポジションを追加しました"
    else
      redirect_to wants_edit_team_path(params[:permalink])
    end
  end

  def update
    wanted_position = WantedPosition.find(params[:id])
    wanted_position.update(wanted_position_params)
    if wanted_position.save
      redirect_to wants_edit_team_path(params[:permalink]), notice: "募集ポジションを更新しました"
    else
      redirect_to wants_edit_team_path(params[:permalink])
    end
  end

  def destroy
    wanted_position = WantedPosition.find(params[:id])
    wanted_position.destroy!
    redirect_to wants_edit_team_path(params[:permalink]), notice: "募集ポジションを削除しました"
  end

  private

  def wanted_position_params
    params.require(:wanted_position).permit(:team_id, :name_id, :amount)
  end
end
