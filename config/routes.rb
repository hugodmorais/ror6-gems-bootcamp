Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  devise_for :users
  resources :courses do
    get :purchased, :pending_review, :created_courses, on: :collection
    resources :enrollments, only: [:new, :create]
    resources :lessons
  end
  resources :users, only: [:index, :edit, :show, :update]
  get 'home/index'
  get 'activity', to: 'home#activity'
  root 'home#index'
end
