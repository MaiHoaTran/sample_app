class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  has_secure_password
  validates :email, presence: true,
    length: {maximum: Settings.user.max_length_email},
    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: Settings.user.min_length_password},
    allow_nil: true
  validates :name, presence: true,
    length: {maximum: Settings.user.max_length_name}

  before_save{email.downcase!}
  before_create :create_activation_digest

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update remember_digest: nil
  end

  def activate
    update activated: true
    update activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
