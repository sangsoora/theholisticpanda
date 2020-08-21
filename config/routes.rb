Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  get '/become-a-practitioner', to: 'pages#become_a_practitioner', as: :become_a_practitioner

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

  resources :users, only: [:show] do
    resources :practitioners, only: [:new, :create]
    resources :favorites, only: [:create]
  end

  resources :favorites, only: [:destroy]

  get 'users/:id/sessions', to: 'users#booking', as: :user_sessions

  resources :practitioners, only: [:index, :show, :update, :destroy] do
    resources :practitioner_specialties, only: [:create]
    resources :practitioner_languages, only: [:create]
    resources :practitioner_social_links, only: [:create]
  end

  get 'practitioners/:id/profile', to: 'practitioners#profile', as: :practitioner_profile
  get 'practitioners/:id/services', to: 'practitioners#service', as: :practitioner_services

  resources :practitioner_specialties, only: [:destroy]

  resources :practitioner_languages, only: [:destroy]

  resources :practitioner_social_links, only: [:destroy]

  resources :languages, only: [:create, :destroy]

  resources :specialties, only: [:create, :destroy] do
    resources :specialty_health_goals, only: [:create]
  end

  resources :health_goals, only: [:create, :destroy]

  resources :services, only: [:create, :index, :show, :update, :destroy] do
    resources :sessions, only: [:create]
  end

  resources :sessions, only: [:show, :edit, :update, :destroy] do
    resources :payments, only: [:new]
  end

  mount StripeEvent::Engine, at: '/stripe-webhooks'
end
