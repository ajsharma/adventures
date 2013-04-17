Moments::Application.routes.draw do
  root :to => "moments#index"
  
  resources :users, :only => [:index, :show, :edit, :update ]

  resources :moments do 
    resources :responses
  end

  match '/moments/:id/heart' => 'moments#heart', :as => :heart_moment, :via => :post
  match '/m/:muddle' => 'moments#shared', :as => :share_moment, :via => :get

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  
end
