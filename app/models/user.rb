require 'openssl'

class User < ApplicationRecord
  # Constants for encrypting password
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  # Creating virtual property
  attr_accessor :password
  # Database realtionship
  has_many :questions, dependent: :nullify
  # Email validation
  validates :email, :username, presence: true, uniqueness: true
  # Name validation
  validates :name, presence: true
  # Username validation
  validates :username, length: { maximum: 40 }
  # Password validation
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  # Color validation
  validates :bg_color, format: { with: /(?<=#)(?<!^)\h{3}/ }

  before_save :encrypt_password
  
  # Encrypting password
  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  # Static method for authentication
  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    return user if user.password_hash == hashed_password
    nil
  end
end
