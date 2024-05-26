Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: :login
  post 'logout', to: 'sessions#destroy', as: :logout
  get 'terms-of-service', to: 'pages#terms_of_service', as: 'terms_of_service'
  get 'privacy-policy', to: 'pages#privacy_policy', as: :privacy_policy

  resources :users, only: [:new, :create, :destroy] do
    collection do
      get 'activate/:token', to: 'users#activate', as: 'activate_user'
      post 'register_email', to: 'users#register_email', as: 'registration'
      post 'complete_registration/:token', to: 'users#complete_registration', as: 'complete_registration'
      post 'resend_activation_mail/:id', to: 'users#resend_activation_mail', as: 'resend_activation_mail'
    end
  end

  resources :diaries do
    collection do
      get 'date/:date', to: 'diaries#redirect_to_diary_or_new', as: :redirect_to_diary_or_new
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "top#index"
end
