class Course < ApplicationRecord
  has_rich_text :description
  
  validates :title, :short_description, :language, :price, :level, presence: true
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

  LANGUAGES = [:"English", :"Russian", :"Polish"]

  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  LEVEL = [:"Beginner", :"Intermediate", :"Advanced", :"N/A"]

  def self.levels
    LEVEL.map { |level| [level, level] }
  end
end
