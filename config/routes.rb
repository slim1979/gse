Rails.application.routes.draw do
  devise_for :users
  resources :attaches

  resources :questions do
    resources :votes, shallow: true do
      patch :click, on: :collection
    end
    resources :answers, shallow: true do
      patch :assign_best, on: :member
      resources :votes, shallow: true do
        patch :click, on: :collection
      end
    end
  end
  root 'questions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
