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
  has_many :user_tag_names, through: :user_tags

  has_one :twitter, dependent: :destroy
  has_one :github, dependent: :destroy

  has_many :skills, dependent: :destroy
  has_many :portfolios, dependent: :destroy
  has_many :positions, dependent: :destroy
  has_many :position_names, through: :positions
  has_many :members, dependent: :destroy

  has_many :owner_teams, class_name: "Team", foreign_key: :owner_user_id
  has_many :member_teams, through: :members, source: :team

  has_many :join_requests, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :invited_teams, through: :invitations, source: :team

  has_many :invitation_names, -> { where(positions: {name_id: Thread.current[:users_hyper_sort]}) }, through: :positions, source: :position_name

  accepts_nested_attributes_for :twitter
  accepts_nested_attributes_for :github

  scope :hyper_sort, ->(current_user) do
    if current_user.nil?
      order(created_at: :desc)
    else
      where.not(id: current_user.id).left_joins(:invitation_names).group(:id).order("count(position_names.id) desc")
    end
  end

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

  def invitable?(current_user)
    if current_user
      unless current_user.id == self.id
        positions = Thread.current[:users_hyper_sort]

        self.positions.each do |position|
          return true if positions.include? position.name_id
        end
      end
      false
    else
      false
    end
  end
end
