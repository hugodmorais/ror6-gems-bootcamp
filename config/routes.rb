Rails.application.routes.draw do
  devise_for :users
  resources :courses
  resources :users, only: [:index]
  get 'home/index'
  get 'home/activity'
  root 'home#index'
end
