class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError
  end

  #rescue_from StandardError, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Forbidden, with: :render_403

  private

  def render_403
    render file: Rails.root.join("public/403.html"), status: 403, layout: false, content_type: "text/html"
  end

  def render_404
    render file: Rails.root.join("public/404.html"), status: 404, layout: false, content_type: "text/html"
  end

  def render_500
    render file: Rails.root.join("public/500.html"), status: 500, layout: false, content_type: "text/html"
  end
end
