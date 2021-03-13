class HomeController < ApplicationController
  def top
    if user_signed_in?
      current_positions = Set.new
      wanted_positions = Set.new

      current_user.position_names.pluck(:id).each do |position|
        current_positions.add position
      end

      current_user.owner_teams.each do |team|
        team.position_names.each do |position|
          wanted_positions.add position.id
        end
      end

      Thread.current[:users_hyper_sort] = wanted_positions
      Thread.current[:teams_hyper_sort] = current_positions

      @users = User.hyper_sort(current_user).limit(8)
      @teams = Team.hyper_sort(current_user).limit(6)
      render "home/show"
    else
      @teams = Team.order(created_at: :desc).limit(8)
      render "home/index"
    end
  end

  def terms
  end

  def privacy
  end

end
