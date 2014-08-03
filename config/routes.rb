Rails.application.routes.draw do

  resources :festivals, only: [:show] do
    member do
      get 'study'
    end
  end

  resources :artists, controller: :artist, only: [:show]

  root 'fesdy#index', as: :fesdy
end
