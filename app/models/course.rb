class Course < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller&.current_user }

  has_rich_text :description
  
  validates :title, :short_description, :language, :price, :level, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  
  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :enrollments

  extend FriendlyId
  friendly_id :generate_slug, use: :slugged

  def generate_slug
    require 'securerandom'
    
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  end

  def to_s
    title
  end

  LANGUAGES = [:"English", :"Russian", :"Polish"]

  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  LEVEL = [:"Beginner", :"Intermediate", :"Advanced", :"N/A"]

  def self.levels
    LEVEL.map { |level| [level, level] }
  end

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column(:average_rating, (enrollments.average(:rating).round(2).to_f))
    else
      update_column(:average_rating, (0))
    end
  end
end
