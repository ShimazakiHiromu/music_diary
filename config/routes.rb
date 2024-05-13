# frozen_string_literal: true

Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: :login
  post 'logout', to: 'sessions#destroy', as: :logout

  resources :users, only: [:new, :create, :destroy]

  resources :diaries

  get "up" => "rails/health#show", as: :rails_health_check

  root "top#index"
end