Rails.application.routes.draw do
  get 'tags/index'
  get 'comments/create'
  get 'public/home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  
  resources :blogs do
    resources :posts do
      resources :comments

    end 
  end

  get '/bycategory' => 'blogs#bycategory', :as => :category_show
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'
  get 'sessions/destroy' => 'sessions#destroy'
  get 'comments/upvote' => 'comments#upvote'
  resources :users
  resources :tags
  resources :kinds
  get 'kinds/show' => 'kinds#show'
  get 'tags/show' => 'tags#show'
  get '/bytags' => 'posts#bytags'
  resources :admins
  
  
  root 'public#home'
end
