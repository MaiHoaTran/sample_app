class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content_length}
  validate :picture_size

  private

  def picture_size
    errors.add(:picture, Settings.micropost.picture_error) if picture.size > Settings.micropost.picture_size.megabytes
  end
end
