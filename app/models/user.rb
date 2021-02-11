class User < ApplicationRecord
  include FriendlyId
  mount_uploader :image, UserImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:twitter, :github]

  friendly_id :permalink

  validates :email,
            presence: {message: "入力してください"},
            uniqueness: {case_sensitive: true, message: "そのメールアドレスは既に使用されています"}

  validates :permalink,
            presence: {message: "入力してください"},
            uniqueness: {case_sensitive: true, message: "そのユーザーIDは既に使用されています"},
            length: {maximum: 24, message: "24字以内で入力してください"}
  validates :name,
            presence: {message: "入力してください"},
            length: {maximum: 24, message: "24字以内で入力してください"}

  has_many :user_tags, dependent: :destroy
  has_many :user_tag_names, through: :user_tags, dependent: :destroy

  has_one :twitter, dependent: :destroy
  has_one :github, dependent: :destroy

  has_many :skills, dependent: :destroy
  has_many :portfolios, dependent: :destroy
  has_many :positions, dependent: :destroy
  has_many :position_names, through: :positions, dependent: :destroy

  has_many :owner_teams, class_name: "Team"

  accepts_nested_attributes_for :twitter
  accepts_nested_attributes_for :github

  def send_on_create_confirmation_instructions
    generate_confirmation_token! unless @raw_confirmation_token
    send_devise_notification :confirmation_on_create_instructions, @raw_confirmation_token
  end

  def update_without_current_password(params, *options)
    params.delete :current_password
    if params[:password].blank? and params[:password_confirmation].blank?
      params.delete :password
      params.delete :password_confirmation
    end

    result = update params, *options
    clean_up_passwords
    result
  end

  def invitable?(user)
    if user
      false
    else
      false
    end
  end
end
