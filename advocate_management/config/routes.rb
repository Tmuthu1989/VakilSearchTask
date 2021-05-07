Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'
  mount LetterOpenerWeb::Engine, at: "/mails" if Rails.env.development?
  devise_for :users
  resources :juniors
  post "/add_juniors" => "juniors#add_juniors"
  resources :cases do
  	get :reject
  end
end
