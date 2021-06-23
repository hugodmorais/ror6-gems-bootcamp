Rails.application.routes.draw do
  resources :enrollments
  devise_for :users
  resources :courses do
    resources :enrollments, only: [:new, :create]
    resources :lessons
  end
  resources :users, only: [:index, :edit, :show, :update]
  get 'home/index'
  get 'activity', to: 'home#activity'
  root 'home#index'
end
