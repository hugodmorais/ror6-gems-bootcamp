class Course < ApplicationRecord
  has_rich_text :description
  
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  
  belongs_to :user
  
  extend FriendlyId
  friendly_id :generate_slug, use: :slugged

  def generate_slug
    require 'securerandom'
    
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  end

  def to_s
    slug
  end
end
