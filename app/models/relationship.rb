class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User", inverse_of: :active_relationships
  belongs_to :followed, class_name: "User", inverse_of: :passive_relationships
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
