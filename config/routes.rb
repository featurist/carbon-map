# frozen_string_literal: true

Rails.application.routes.draw do
  resource :address, only: %i[edit update]
  get '/address' => 'addresses#edit'
  resources :subscriptions, only: %i[new create update index show]
  devise_for :users
  get 'home/index'
  get '/thanks' => 'home#thanks'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
end
