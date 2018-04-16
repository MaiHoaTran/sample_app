class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true,
    length: {maximum: Settings.user.max_length_email},
    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.min_length_password}
  validates :name, presence: true,
    length: {maximum: Settings.user.max_length_name}

  before_save{email.downcase!}
end