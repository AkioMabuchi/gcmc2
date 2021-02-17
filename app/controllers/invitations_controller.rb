class InvitationsController < ApplicationController
  def index
    @invitations = Invitation.where(user_id: current_user.id)
  end

  def create
    invitation = Invitation.new(invitation_params)
    if invitation.save
      redirect_to user_path(invitation.user_id), notice: "招待しました"
    else
      redirect_to user_path(invitation.user_id)
    end
  end

  def destroy
    invitation = Invitation.find(params[:id])
    invitation.destroy!
    redirect_to user_path(invitation.user_id), notice: "招待を取り消しました"
  end

  def accept
    invitation = Invitation.find(params[:id])
    member = Member.new(
        user_id: invitation.user_id,
        team_id: invitation.team_id,
        position_name_id: invitation.position_name_id
    )
    member.save!

    wanted_position = WantedPosition.find_by(team_id: invitation.team_id, name_id: invitation.position_name_id)
    if wanted_position
      wanted_position.amount -= 1
      if wanted_position.amount > 0
        wanted_position.save!
      else
        wanted_position.destroy!
      end
    end

    invitation.destroy!

    redirect_to team_path(invitation.team.permalink), notice: "招待を受諾し、チームに加入しました"
  end

  def reject

    invitation = Invitation.find(params[:id])
    invitation.destroy!

    redirect_to invitations_path, notice: "招待を拒否しました。"
  end

  private

  def login_user_only

  end

  def authenticate_user

  end

  def invitation_params
    params.require(:invitation).permit(:user_id, :team_id, :position_name_id)
  end
end