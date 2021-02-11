class TwittersController < ApplicationController
  def destroy
    current_user.twitter.destroy!
    redirect_to edit_sns_user_registration_path, notice: "Twitterとの連携を解除しました"
  end
end
