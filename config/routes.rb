Rails.application.routes.draw do

  resources :festivals, only: [:show]

  get 'festivals/show'

  root 'fesdy#index', as: :fesdy
end
