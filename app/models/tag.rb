class Tag < ApplicationRecord
  has_many :course_tags, dependent: :destroy
  has_many :courses, through: :course_tags

  validates :name, length: { minimum: 1, maximum: 25 }, uniqueness: true

  scope :selected, -> { where.not(course_tags_count: 0).order(course_tags_count: :desc) }
end