Rails.application.routes.draw do
  devise_for :users
  root to: "chats#_chats"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resources :users do
  #   resources :messages, only: [:index, :new, :create]
  resources :users do
    resources :messages, only: [:index]
  end

  resources :messages, only: [:create], as: :messages
end
