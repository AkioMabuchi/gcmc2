class Team < ApplicationRecord
  include FriendlyId

  belongs_to :user, foreign_key: :owner_user_id

  mount_uploader :image, TeamImageUploader

  friendly_id :permalink

  has_many :team_tags, dependent: :destroy
  has_many :team_tag_names, through: :team_tags

  has_many :wanted_positions, dependent: :destroy
  has_many :position_names, through: :wanted_positions

  validates :permalink,
            presence: {message: "入力してください"},
            uniqueness: {case_sensitive: true, message: "そのチームIDは既に使われています"},
            length: {maximum: 24, too_long: "24字以内で入力してください"}
  validates :name,
            presence: {message: "入力してください"},
            uniqueness: {case_sensitive: false, message: "そのチーム名は既に使われています"},
            length: {maximum: 24, too_long: "24字以内で入力してください"}
  validates :title, length: {maximum: 100, too_long: "100字以内で入力してください"}
end
