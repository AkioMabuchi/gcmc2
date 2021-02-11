class Position < ApplicationRecord
  belongs_to :user
  belongs_to :position_name, foreign_key: :name_id
end
