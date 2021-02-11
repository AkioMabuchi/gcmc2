class GithubsController < ApplicationController
  def destroy
    current_user.github.destroy!
    redirect_to edit_sns_user_registration_path, notice: "GitHubとの連携を解除しました"
  end
end
