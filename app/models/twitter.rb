class Twitter < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: {case_sensitive: true}
  validates :uid, presence: true, uniqueness: {case_sensitive: true}
  validates :url, presence: true
end
