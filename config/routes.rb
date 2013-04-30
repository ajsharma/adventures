Adventures::Application.routes.draw do
  root :to => "adventures#index"
  
  resources :users, :only => [:index, :show, :edit, :update ]

  resources :adventures do 
    resources :responses
  end

  match '/adventures/:id/heart' => 'adventures#heart', :as => :heart_adventure, :via => :post
  match '/m/:muddle' => 'adventures#shared', :as => :share_adventure, :via => :get

  match 'welcome' => 'pages#welcome', :as => :welcome_page

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  
end
