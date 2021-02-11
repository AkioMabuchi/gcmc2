class SettingInvitationsController < ApplicationController
  def index
    @react_info = {
        authenticityToken: form_authenticity_token,
        userId: current_user.id,
        invitations: current_user.positions.joins(:position_name).order(sort_number: :asc).select(:id, :name_id, :name),
        positions: PositionName.all.order(sort_number: :asc).select(:id, :name)
    }
  end

  def create
    position = Position.new(position_params)
    position.save!
    redirect_to setting_invitations_path, notice: "招待ポジションを追加しました"
  end

  def destroy
    position = Position.find(params[:id])
    position.destroy!
    redirect_to setting_invitations_path, notice: "招待ポジションを削除しました"
  end

  private

  def position_params
    params.require(:position).permit(:user_id, :name_id)
  end
end
