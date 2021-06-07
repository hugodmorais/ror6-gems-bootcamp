Rails.application.routes.draw do
  resources :lessons
  devise_for :users
  resources :courses
  resources :users, only: [:index, :edit, :show, :update]
  get 'home/index'
  get 'home/activity'
  root 'home#index'
end
