class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  
  rolify
  has_many :courses
  after_create :assign_default_role

  extend FriendlyId
  friendly_id :generate_slug, use: :slugged

  def generate_slug
    require 'securerandom'
    
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  end

  validate :must_have_a_role, on: :update

  def to_s
    email
  end

  def username
    self.email.split(/@/).first
  end

  def assign_default_role
    if User.count == 1
      add_role(:admin) if roles.blank?
      add_role(:teacher)
      add_role(:student)
    else
      add_role(:teacher)
      add_role(:student)
    end
  end

  def online?
    updated_at > 2.minutes.ago
  end

  private

  def must_have_a_role
    return if roles.any?
    
    errors.add(:roles, "must have at least one role")
  end
end
