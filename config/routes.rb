Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do 
      get '/merchants/find', to: 'merchant_search#find'
      get '/items/find_all', to: 'item_search#find_all'
      get '/items/find', to: 'item_search#find'

      resources :merchants do
        get '/items', to: 'merchants#items'
      end

      resources :items do
        get 'merchant', to: 'items#merchant'
      end
    end
  end
end
