class Team < ApplicationRecord
  belongs_to :user, foreign_key: :owner_user_id

  mount_uploader :image, TeamImageUploader

  validates :permalink,
            presence: {message: "入力してください"},
            uniqueness: {case_sensitive: true, message: "そのチームIDは既に使われています"},
            exclusion: {in: ["new"]}
  validates :name, presence: {message: "入力してください"}, uniqueness: {case_sensitive: false, message: "そのチーム名は既に使われています"}
end
