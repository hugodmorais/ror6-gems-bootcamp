class Courses::CourseWizardController < ApplicationController
  include Wicked::Wizard
  before_action :set_progress, only: [:show, :update]
  before_action :set_course, only: [:show, :update, :finish_wizard_path]

  steps :basic_info, :details, :lessons

  def show
    authorize @course, :edit?
    # @user = current_user
    case step
    when :basic_info
    when :lessons
    when :details
      @tags = Tag.all
    end
    # when :find_friends
    #   @friends = @user.find_friends
    # end
    render_wizard
  end

  def update
    authorize @course, :edit?
    case step
    when :basic_info
      @course.update(course_params)
    when :lessons
      @course.update(course_params)
    when :details
      @tags = Tag.all
      @course.update(course_params)
    end
    render_wizard @course
  end

  def finish_wizard_path
    authorize @course, :edit?
    course_path(@course)
  end

  private

  def set_progress
    if wizard_steps.any? && wizard_steps.index(step).present?
      @progress = ((wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d) * 100
    else
      @progress = 0
    end
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def course_params
    params.require(:course).permit(
      :title, 
      :description, 
      :short_description, 
      :language, 
      :price, 
      :level, 
      :published, 
      :avatar, 
      tag_ids: [],
      lessons_attributes: [:id, :title, :content, :destroy]
    )
  end
end
