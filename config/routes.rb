Rails.application.routes.draw do
  root 'posts#index'
  
  devise_for :users
  resources :users, only: [:index, :show] do
    member do
      get :following, :followers
    end
  end
  resources :posts, only: [:index, :show, :new, :create, :destroy] do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  
  resources :messages, only: [:create, :destroy]
  resources :rooms, only: [:create, :index, :show]
  resources :notifications, only: :index
end
