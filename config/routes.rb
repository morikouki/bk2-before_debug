Rails.application.routes.draw do

  get 'favorites/create'
  get 'favorites/destroy'
  get 'create/destroy'
  root 'home#top'
  get 'home/about'
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update]
  resources :books do
  	resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

end