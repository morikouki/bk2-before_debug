Rails.application.routes.draw do

  root 'home#top'
  get 'home/about'
  devise_for :users do
      member do
        get :following, :followers
      end
    end
resources :follow_relationships, only: [:create, :destroy]
  resources :users,only: [:show,:index,:edit,:update]
  resources :books do
  	resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

end