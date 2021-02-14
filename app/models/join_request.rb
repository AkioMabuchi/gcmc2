class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :position_name
end
