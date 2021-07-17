class Course < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller&.current_user }

  has_rich_text :description
  has_one_attached :avatar
  
  validates :title, :description, :short_description, :language, :price, :level, presence: true
  validates :description, length: { minimum: 5 }
  validates :short_description, length: { maximum: 300 }
  validates :title, uniqueness: true, length: { maximum: 70 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :avatar, presence: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 1000.kilobytes, message: 'size should be under 1000 kilobytes' }
  # validates :avatar, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 1000.kilobytes, message: 'size should be under 1000 kilobytes' }

  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons

  scope :latest_courses, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :approved, -> { where(approved: true) }
  scope :unpublished, -> { where(published: false) }
  scope :unapproved, -> { where(approved: false) }

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

  def progress(user)
    return if self.lessons_count.zero?

    ((user_lessons.where(user: user).count).to_f/(self.lessons_count).to_f).to_f*100
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column(:average_rating, (enrollments.average(:rating).round(2).to_f))
    else
      update_column(:average_rating, (0))
    end
  end
end
