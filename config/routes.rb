Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'
  #get 'pages/index'

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show]
end
