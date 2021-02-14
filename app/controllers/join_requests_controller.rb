class JoinRequestsController < ApplicationController
  def create
    join_request = JoinRequest.new(join_request_params)

    if join_request.save
      # todo ここにメール通知処理を追記する
      redirect_to team_path(params[:permalink]), notice: "加入申請を行いました"
    else
      redirect_to team_path(params[:permalink])
    end
  end

  def destroy
    join_request = JoinRequest.find(params[:id])
    join_request.destroy!

    # todo ここにメール通知処理を追記する

    redirect_to team_path(params[:permalink]), notice: "加入申請を取り消しました"
  end

  def accept
    join_request = JoinRequest.find(params[:id])
    member = Member.new(
        user_id: join_request.user_id,
        team_id: join_request.team_id,
        position_name_id: join_request.position_name_id
    )
    member.save!

    wanted_position = WantedPosition.find_by(team_id: join_request.team_id, name_id: join_request.position_name_id)
    if wanted_position
      wanted_position.amount -= 1
      if wanted_position.amount > 0
        wanted_position.save!
      else
        wanted_position.destroy!
      end
    end
    join_request.destroy!

    redirect_to team_path(params[:permalink]), notice: "加入申請を受諾しました"
  end

  def reject
    join_request = JoinRequest.find(params[:id])
    join_request.destroy!

    redirect_to team_path(params[:permalink]), notice: "加入申請を拒否しました"
  end

  private

  def join_request_params
    params.require(:join_request).permit(:user_id, :team_id, :position_name_id, :message)
  end
end
