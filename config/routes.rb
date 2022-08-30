Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants do
        get '/items', to: 'items#merc_index'
      end
      
      resources :items
    end
  end
end
