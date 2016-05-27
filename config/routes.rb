Rails.application.routes.draw do

  resources :products
  namespace :admin do
    resources :videos do
      collection do
        post 'update_row_order'
      end
    end
    
    resources :tags do
      collection do
        post 'update_row_order'
      end
    end

    resources :themes do
      member do
        put 'activate'
        put 'deactivate'
        get 'preview'
      end
    end
    
    resources :photos do
      collection do
        post 'update_row_order'
        get 'add', to: "photos#new"
      end
    end
    get 'dashboard/index'
    root to: 'dashboard#index'
  end

  get 'home/index'
  root to: 'home#index'
end
