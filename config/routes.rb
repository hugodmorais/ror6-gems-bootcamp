Rails.application.routes.draw do
  resources :youtube, only: :show

  resources :enrollments do
    get :my_students, on: :collection
    member do
      get :certificate
    end
  end
  devise_for :users, :controllers => { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  
  resources :tags, only: [:create, :index, :destroy]
  resources :courses do
    get :purchased, :pending_review, :created_courses, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :course_wizard, controller: 'courses/course_wizard'
    resources :enrollments, only: [:new, :create]
    resources :lessons do
      resources :comments
      put :sort
      member do
        delete :delete_video
      end
    end
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
  get 'privacy_policy', to: 'home#privacy_policy'
  root 'home#index'
end
