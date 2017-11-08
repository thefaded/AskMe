Rails.application.routes.draw do
  root 'users#index'

  resources :users
  resources :questions, except: [:show, :new]
  resources :sessions, only: [:new, :create, :destroy]

  # Custom routes
  get 'signup' => 'users#new'
  get 'logout' => 'sessions#destroy'
  get 'login' => 'sessions#new'
end
