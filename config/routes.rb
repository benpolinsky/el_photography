Rails.application.routes.draw do


  namespace :admin do
    
    resources :products do
      collection do
        post 'create_from_photo/:photo_id' => 'products#create_from_photo', as: :create_from_photo
      end
      resources :variants
    end
    
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
  
  
  # Store 
  
  get 'store/index' => 'store#index', as: :store
  get 'store/product/:id' => 'store#product', as: :product
  get 'store/help' => 'store#help', as: :help
  
  scope '/store' do
    resource :cart do
      post 'add_item'
      put 'change_item_quantity'
      put 'change_item_quantity_to'
      get 'empty'
    end
    
    resource :orders
    get 'checkout' => 'orders#new', as: :checkout
  end
  
  get 'home/index'
  root to: 'home#index'
end
