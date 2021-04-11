class Team < ApplicationRecord
  include FriendlyId
  mount_uploader :image, TeamImageUploader

  friendly_id :permalink


  validates :permalink,
            format: {with: /\A[0-9a-zA-Z\\-]*\z/, message: "英数字およびハイフンのみ使えます"},
            presence: {message: "入力してください"},
            uniqueness: {case_sensitive: true, message: "そのチームIDは既に使われています"},
            length: {maximum: 24, too_long: "24字以内で入力してください"}
  validates :name,
            presence: {message: "入力してください"},
            uniqueness: {case_sensitive: false, message: "そのチーム名は既に使われています"},
            length: {maximum: 24, too_long: "24字以内で入力してください"}
  validates :title, length: {maximum: 100, too_long: "100字以内で入力してください"}

  validates :not_adult, acceptance: {message: "同意してください"}

  belongs_to :user, foreign_key: :owner_user_id

  has_many :members, dependent: :destroy
  has_many :member_users, through: :members, source: :user

  has_many :team_tags, dependent: :destroy
  has_many :team_tag_names, through: :team_tags

  has_many :wanted_positions, dependent: :destroy
  has_many :position_names, through: :wanted_positions

  has_many :join_requests, dependent: :destroy
  has_many :invitations, dependent: :destroy

  has_many :team_urls, dependent: :destroy

  has_many :wanted_names, -> { where(wanted_positions: {name_id: Thread.current[:teams_hyper_sort]}) }, through: :wanted_positions, source: :position_name
  scope :hyper_sort, ->(current_user) do
    if current_user
      where.not(owner_user_id: current_user.id).left_joins(:wanted_names).group(:id).order("count(position_names.id) desc")
    else
      order(created_at: :desc)
    end
  end

  def wanted?(current_user)
    if current_user
      positions = Thread.current[:teams_hyper_sort]
      self.position_names.pluck(:id).each do |position_id|
        if positions.include? position_id
          return true
        end
      end
      false
    else
      false
    end
  end

  def owner?(current_user)
    if current_user
      self.owner_user_id == current_user.id
    else
      false
    end
  end

  def member?(current_user)
    if current_user
      self.members.each do |member|
        return true if member.user_id == current_user.id
      end
      false
    else
      false
    end
  end

  def join_request(current_user)
    JoinRequest.find_by(user_id: current_user.id, team_id: self.id)
  end

  def has_url?(current_user)
    members = Set.new
    self.members.each do |member|
      members.add member.user_id
    end

    self.team_urls.each do |url|
      if url.is_public
        return true
      elsif current_user
        if self.owner_user_id == current_user.id
          return true
        end
        if members.include? current_user.id
          return true
        end
      end
    end
    false
  end
end
