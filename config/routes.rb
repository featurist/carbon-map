# frozen_string_literal: true

Rails.application.routes.draw do
  resources :groups do
    resources :group_websites
  end
  resources :tags
  scope '/admin' do
    resources :initiative_statuses
    resources :group_types
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
end
