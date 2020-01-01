# frozen_string_literal: true

Rails.application.routes.draw do
  resource :about, only: %i[show]
  resource :contact, only: %i[show]
  resources :districts, only: %i[index show]
  resources :initiatives, only: %i[index new edit create update]
  resources :groups, only: %i[index new edit create update]
  resources :tags
  scope '/admin' do
    resources :initiative_statuses, only: %i[index new edit create update]
    resources :group_types, only: %i[index new edit create update]
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
end
