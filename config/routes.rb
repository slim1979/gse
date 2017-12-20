Rails.application.routes.draw do
  devise_for :users
  resources :attaches

  resources :questions do
    resources :votes, shallow: true
    resources :answers, shallow: true do
      patch :assign_best, on: :member
      resources :votes, shallow: true
    end
  end
  root 'questions#index'
  mount ActionCable.server => '/cable'
end
