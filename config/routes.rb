Rails.application.routes.draw do
  resources :tasks
  devise_for :users
  get 'home/about'
  root "home#index"

  get '*', to: 'errors#not_found', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :conversations do
    member do
      get 'modal'
    end
  end
  
  resources :chat_messages
end
