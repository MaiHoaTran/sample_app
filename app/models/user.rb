class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true,
    length: {maximum: Settings.user.max_length_email},
    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: Settings.user.min_length_password}
  validates :name, presence: true,
    length: {maximum: Settings.user.max_length_name}

  before_save{email.downcase!}

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
