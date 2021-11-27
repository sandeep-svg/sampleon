Rails.application.routes.draw do
  get 'upload/process_data'
  get 'vaccine/check_availability'
  post 'Get the details', to: 'vaccine#check_availability', as: 'vaccine'
  root 'static_pages#home'
  get 'static_pages/home'
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :create, :new, :edit, :update]
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'logout' => 'sessions#destroy'
  post 'upload' => 'upload#process_data'
  get 'gst' => 'upload#new_gst'
  get 'password_reset' => 'users#password_reset'
  post 'update password', to: 'users#update_password', as: 'password'
  get 'verify_otp' => 'users#otp_verify'
  post 'verify_otp', to: 'users#otp_check', as: 'otp'
  get 'login_otp' => 'sessions#login_with_otp'
  get 'login_methods' => 'sessions#login_methods'
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts 
end
