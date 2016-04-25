Rails.application.routes.draw do
  resources :videos
  get 'home/index'

  resources :photos
  
  root to: 'home#index'
end
