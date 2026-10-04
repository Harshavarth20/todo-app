Rails.application.routes.draw do
  devise_for :users

  resources :todos

mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "todos#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
