Rails.application.routes.draw do
  root to: 'sessions#new'

  resources :sessions, only: [:new, :create]
  get 'login', controller: :sessions, action: :new
  get 'logout', to: 'sessions#destroy', as: :logout
  get 'maintenance', to: 'sessions#maintenance', as: :maintenance

  resources :reset_passwords, except: [:index, :destroy, :show]
  get 'reset_password', controller: :reset_passwords, action: :new, as: :new_password

  resources :registrations, only: [:new, :create] do
    member do
      get 'activate'
    end
  end

  get 'dashboard', to: 'home#dashboard'
  get '/change_language/:locale', to: 'application#change_locale', as: :change_language
end
