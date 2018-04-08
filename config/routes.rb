require 'sidekiq/web'

Rails.application.routes.draw do
  resources :searches
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post 'emails', to: 'omniauth_callbacks#request_email'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers
      end
    end
  end

  resources :subscriptions
  resources :attaches

  resources :authorizations do
    get :confirm_email, on: :member
  end

  resources :questions do
    resources :votes, shallow: true
    resources :comments
    resources :answers, shallow: true do
      patch :assign_best, on: :member
      resources :comments
      resources :votes, shallow: true
    end
  end

  root 'questions#index'
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web, at: '/sidekiq'
end
