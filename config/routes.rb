Rails.application.routes.draw do
  get 'comments/create'
  get 'public/home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  
  resources :blogs do
    resources :posts do
      resources :comments
    end 
  end

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'
  get 'sessions/destroy' => 'sessions#destroy'
  resources :users
  resources :tags
  
  resources :admins
  
  
  root 'public#home'
end
