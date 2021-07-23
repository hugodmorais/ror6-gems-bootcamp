class CommentPolicy < ApplicationPolicy
  def destroy?
    @user.has_role?(:admin) ||
      @record.user == @user ||
      @record.lesson.course.user == @user
  end
end
