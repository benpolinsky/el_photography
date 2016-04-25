Rails.application.routes.draw do
  namespace :admin do

  end

  namespace :admin do
    resources :videos, :photos
    get 'dashboard/index'
    root to: 'dashboard#index'
  end

  get 'home/index'
  root to: 'home#index'
end
