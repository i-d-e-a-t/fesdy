Rails.application.routes.draw do

  resources :festivals, only: [:show]
  resources :artist, only: [:show]

  root 'fesdy#index', as: :fesdy
end
