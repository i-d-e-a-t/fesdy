Rails.application.routes.draw do

  resources :festivals, only: [:show] do
    member do
      get 'study'
    end

    resources :festival_dates, path: :dates, as: :dates, only: [:show] do
      get 'study' => 'festivals#study'
    end
  end

  resources :artists, controller: :artist, only: [:show]

  root 'fesdy#index', as: :fesdy
end
