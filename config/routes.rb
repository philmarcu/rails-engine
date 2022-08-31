Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do 
      get '/merchants/find', to: 'merchants_search#find'
      get '/items/find_all', to: 'items_search#find_all'

      resources :merchants do
        get '/items', to: 'merchants#items'
      end

      
      resources :items do
        get 'merchant', to: 'items#merchant'
      end
    end
  end
end
