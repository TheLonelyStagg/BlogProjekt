Rails.application.routes.draw do
  get 'public/home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  
  resources :blogs do
    resources :posts do
      resources :comments
    end 
  end
    
  
  resources :users
  
  resources :admins
  
  
  root 'public#home'
end
