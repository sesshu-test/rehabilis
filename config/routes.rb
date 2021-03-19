Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  get 'pages/index'

  #get 'users/show'
  #get 'users/index'
  resources :users, only: [:index, :show]
end
