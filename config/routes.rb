Rails.application.routes.draw do
  concern :orderable do
    collection do
      post 'update_row_order'
    end
  end
 

  devise_for :users, skip: [:registrations]
  namespace :admin do
    
    resources :products, concerns: :orderable do
      collection do
        post 'create_from_photo/:photo_id' => 'products#create_from_photo', as: :create_from_photo
      end
      resources :variants
    end
    
    resources :videos, concerns: :orderable
    
    resources :tags, concerns: :orderable

    resources :themes, concerns: :orderable do
      member do
        put 'activate'
        put 'deactivate'
        get 'preview'
      end
    end
    
    resources :page_templates
    
    resources :photos, concerns: :orderable do
      collection do
        get 'add', to: "photos#new"
      end
    end
    
    resources :orders do
      member do
        put 'ship'
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
      put 'increase_item_quantity/:item_id' => 'carts#increase_item_quantity', as: :increase_item_quantity
      put 'decrease_item_quantity/:item_id' => 'carts#decrease_item_quantity', as: :decrease_item_quantity
      put 'change_item_quantity'
      put 'change_item_quantity_to'
      get 'empty'
    end
    
    resources :orders do
      member do
        get 'enter_address' => 'orders#enter_address'
        get 'enter_payment' => 'orders#enter_payment'
        get 'receipt' => 'orders#payment_accepted', as: :payment_accepted
        get 'cancel_payment' => 'order#cancel_payment'
      end
      get 'success', on: :collection
      get 'cancel', on: :collection
    end
    get 'checkout' => 'orders#new', as: :checkout

  end
  
  get 'home/index'
  root to: 'home#index'
end
