require 'openssl'

class User < ApplicationRecord
  # Constants for encrypting password
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  # Database realtionship
  has_many :questions

  # Email validation
  validates :email, presence: true
  validates :email, uniqueness: true

  # Creating virtual property
  attr_accessor :password

  # Password validation
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  before_save :encrypt_password

  # Encrypting password
  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  # Static method for authentication
  def self.authenticate(email, password)
    user = find_by(email: email)

    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end
end
