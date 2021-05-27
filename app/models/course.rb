class Course < ApplicationRecord
  has_rich_text :description

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  belongs_to :user

  def to_s
    description
  end
end
