Moments::Application.routes.draw do
  root :to => "moments#index"
  
  resources :users, :only => [:index, :show, :edit, :update ]
  resources :moments
  
  match '/m/:muddle' => 'moments#show', :as => :muddle_moment

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  
end
