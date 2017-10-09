Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    delete :attach, on: :member
    resources :answers, shallow: true do
      delete :attach, on: :member
      patch :best_answer_assign, on: :member
    end
  end
  root 'questions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
