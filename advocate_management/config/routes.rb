Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'
  mount LetterOpenerWeb::Engine, at: "/mails" if Rails.env.development?
  devise_for :users
  resources :juniors, controller: :users
  resources :cases
end
