Rails.application.routes.draw do

  root 'fesdy#index'
  get 'fesdy' => 'fesdy#index'
end
