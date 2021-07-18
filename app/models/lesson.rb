class Lesson < ApplicationRecord
  has_one_attached :video
  has_one_attached :video_thumbnail

  belongs_to :course, counter_cache: true
  has_many :user_lessons, dependent: :destroy

  validates :title, :content, :course, presence: true
  validates :title, length: { maximum: 70 }
  validates_uniqueness_of :title, scope: :course_id
  validates :video, content_type: ['video/mp4'], size: { less_than: 50.megabytes, message: 'size should be under 50 megabytes' }
  validates :video_thumbnail, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 1000.kilobytes, message: 'size should be under 1000 kilobytes' }
  # validates :video_thumbnail, presence: true, if: :video_present?
  has_rich_text :content

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  # rancked model gem
  include RankedModel
  ranks :row_order, :with_same => :course_id

  def to_s
    title
  end

  # def video_present?
  #   self.video.present?
  # end

  def prev
    course.lessons.where('row_order < ?', row_order).order(:row_order).last
  end

  def next
    course.lessons.where('row_order > ?', row_order).order(:row_order).first
  end

  def viewed(user)
    self.user_lessons.where(user: user).present?
  end
end
