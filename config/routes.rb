Rails.application.routes.draw do
  root 'posts#index'
  
  devise_for :users
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :new, :create, :destroy]
end
