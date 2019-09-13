class User < ApplicationRecord
  attr_accessor :remember_token

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  mount_uploader :image, ImageUploader

  has_secure_password

  has_many :posts
  has_many :comments


  # Returns true if the given token matches the digest of attribute
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")

    return false if digest.blank?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = self.new_token
    update_attribute(:remember_digest, self.digest(remember_token))
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.from_omniauth(auth_hash)
    user = User.find_by(email: auth_hash['info']['email'])
    if user
      puts " find and update "
      user.uid      = auth_hash['uid']
      user.provider = auth_hash['provider']
      user.name     = auth_hash['info']['name']
      user.image    = auth_hash['info']['image']
      user.token    = auth_hash['credentials']['token']
      user.password = user.new_token
      user.save!

      return user
    else
      puts " create "
      user = User.new(
        uid:      auth_hash['uid'],
        provider: auth_hash['provider'],
        email:    auth_hash['info']['email'],
        name:     auth_hash['info']['name'],
        image:    auth_hash['info']['image'],
        token:    auth_hash['credentials']['token']
      )
      user.password = user.new_token
      user.save!

      return user
    end
  end
end
