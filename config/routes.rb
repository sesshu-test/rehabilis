Rails.application.routes.draw do
  root 'posts#index'
  get "/posts/categorized_posts", to: 'posts#categorized_posts', as: 'categorized_posts'
  #get "/posts/new_rehabilitation", to: 'posts#new_rehabilitation', as: 'new_rehabilitation'
  get 'search' => 'posts#search'
  get "/users/graph", to: 'users#graph', as: 'graph'
  get "/users/myposts", to: 'users#myposts', as: 'myposts'
  get "/users/likes", to: 'users#likes', as: 'likes'
  get "/notifications/notification", to: 'notifications#notification', as: 'notification'
  get "/notifications/activity", to: 'notifications#activity', as: 'activity'
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'
  
  #devise_for :users
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
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
end
