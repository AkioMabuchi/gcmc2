class HomeController < ApplicationController
  def top
    if user_signed_in?
      render "home/show"
    else
      render "home/index"
    end
  end

  def terms
  end

  def privacy
  end


end
