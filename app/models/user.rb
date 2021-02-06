class User < ApplicationRecord
  mount_uploader :image, UserImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:twitter, :github]

  validates :twitter_uid, presence: true, uniqueness: {case_sensitive: true}, allow_nil: true
  validates :github_uid, presence: true, uniqueness: {case_sensitive: true}, allow_nil: true

  def connect_twitter(uid, url)
    self.twitter_uid = uid
    self.twitter_url = url
    self.is_published_twitter = false
    save!
  end

  def connect_github(uid, url)
    self.github_uid = uid
    self.github_url = url
    self.is_published_github = false
    save!
  end

  def update_without_current_password(params, *options)
    params.delete :current_password
    if params[:password].blank? and params[:password_confirmation].blank?
      params.delete :password
      params.delete :password_confirmation
    end

    result = update_attributes params, *options
    clean_up_passwords
    result
  end

end
