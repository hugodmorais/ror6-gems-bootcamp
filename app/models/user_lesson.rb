class UserLesson < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  
  belongs_to :user
  belongs_to :lesson

  validates_uniqueness_of :user_id, scope: :lesson_id
  validates_uniqueness_of :lesson_id, scope: :user_id
end
