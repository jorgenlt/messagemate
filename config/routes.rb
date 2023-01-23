Rails.application.routes.draw do
  devise_for :users
  root to: "chatrooms#index"

  resources :chatrooms, only: [:show, :create] do
    resources :messages, only: :create
  end
end
