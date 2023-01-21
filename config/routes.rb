Rails.application.routes.draw do
  devise_for :users
  root to: "chats#chats"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users do
    resources :messages, only: [:index, :new, :create]
  end
end
