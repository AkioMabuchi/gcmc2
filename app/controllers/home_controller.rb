class HomeController < ApplicationController
  def top
    if user_signed_in?
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
