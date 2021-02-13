class HomeController < ApplicationController
  def index
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

  def contact_form
  end

  def contact

  end
end
