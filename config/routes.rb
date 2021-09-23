Rails.application.routes.draw do
  root 'posts#index'
  get "/posts/return_to_posts", to: 'posts#return_to_posts', as: 'return_to_posts'
  get "/searches/icon_click", to: 'searches#icon_click', as: 'searches_icon_click'
  get "/searches/posts", to: 'searches#posts', as: 'searches_posts'
  get "/searches/users", to: 'searches#users', as: 'searches_users'
  post "/users/guest_sign_in", to: 'users#guest_sign_in'
  get "/users/graph", to: 'users#graph', as: 'graph'
  get "/users/myposts", to: 'users#myposts', as: 'myposts'
  get "/users/likes", to: 'users#likes', as: 'likes'
  get "/notifications/notification", to: 'notifications#notification', as: 'notification'
  get "/notifications/activity", to: 'notifications#activity', as: 'activity'
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'
  
  #devise_for :users
  devise_for :users, :controllers => {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  } 
  resources :users, only: [:index, :show] do
    member do
      get :following, :followers
    end
  end
  resources :posts, only: [:index, :show, :new, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]

  resources :messages, only: [:create, :destroy]
  resources :rooms, only: [:create, :index, :show]
  resources :notifications, only: :index
  resources :hashtags, only: :index
  resources :searches, only: :index
end
