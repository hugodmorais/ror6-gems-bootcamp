Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  devise_for :users
  resources :courses do
    get :purchased, :pending_review, :created_courses, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :enrollments, only: [:new, :create]
    resources :lessons
  end
  resources :users, only: [:index, :edit, :show, :update]

  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end
  get 'home/index'
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'
  root 'home#index'
end
