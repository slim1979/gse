Rails.application.routes.draw do
  devise_for :users
  resources :attaches
  resources :questions do
    resources :answers, shallow: true do
      patch :best_answer_assign, on: :member
    end
  end
  resources :votes, shallow: true do
    patch 'any', on: :collection
  end
  root 'questions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
