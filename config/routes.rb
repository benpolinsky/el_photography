require 'sidekiq/web'
Rails.application.routes.draw do
  
  # serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  
  
  
  concern :orderable do
    collection do
      post 'update_row_order'
    end
  end
 

  devise_for :users, skip: [:registrations]
  mount BpCustomFields::Engine => "admin/custom_fields", as: "bp_custom_fields"
  namespace :admin do
    authenticate :user do
      mount Sidekiq::Web => '/sidekiq'
    end
    resources :products, concerns: :orderable do
      collection do
        post 'create_from_photo/:photo_id' => 'products#create_from_photo', as: :create_from_photo
      end
      resources :variants
    end
    
    resources :users do
      post 'reset_password', on: :member
    end
    
    resources :videos, concerns: :orderable do
      collection do
        get 'reorder', to: "videos#reorder"
      end
    end
    
    resources :tags, concerns: :orderable

    resources :themes, concerns: :orderable do
      member do
        put 'activate'
        put 'deactivate'
        get 'preview'
      end
    end

    get 'page_templates/live_render/:id' => 'page_templates#live_render', as: :page_templates_live_render

    resources :page_templates do
      member do
        get 'live'
        patch 'live_update'
      end
    end
    
    resources :photos, concerns: :orderable do
      collection do
        get 'reorder', to: "photos#reorder"
        get 'add', to: "photos#new"
      end
    end
    
    resources :orders do
      member do
        put 'ship'
      end
    end


    get 'help/liquid'
    get 'dashboard/index'
    root to: 'dashboard#index'
  end

  
  # Store 
  
  get 'prints' => 'store#index', as: :store
  get 'prints/:id' => 'store#product', as: :product
  get 'prints/help' => 'store#help', as: :help
  
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
        get 'payment_accepted' => 'orders#payment_accepted', as: :payment_accepted
        get 'receipt' => 'orders#receipt', as: :receipt
        get 'cancel_payment' => 'order#cancel_payment'
      end
      get 'success', on: :collection
      get 'cancel', on: :collection
    end
    get 'checkout' => 'orders#new', as: :checkout
  end
  

    
  get 'work/:id' => 'home#tag', as: :tag
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  post 'send_message' => 'home#send_message', as: :send_message
  
  get 'home/index'
  
  post 'email_sign_up' => 'home#email_sign_up', as: :email_sign_up
  root to: 'home#index'
end
