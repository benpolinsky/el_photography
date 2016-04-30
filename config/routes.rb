Rails.application.routes.draw do

  namespace :admin do
    resources :videos, :tags

    resources :themes do
      member do
        put 'activate'
        put 'deactivate'
        get 'preview'
      end
    end
    
    resources :photos do
      get 'add', to: "photos#new", on: :collection
    end
    get 'dashboard/index'
    root to: 'dashboard#index'
  end

  get 'home/index'
  root to: 'home#index'
end
