class UserTag < ApplicationRecord
  belongs_to :user
  belongs_to :user_tag_name, foreign_key: :name_id
end
