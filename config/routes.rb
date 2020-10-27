Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'logout' => 'sessions#destroy'
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts 
end
