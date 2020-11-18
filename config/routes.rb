Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { registrations: "registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  get '/become-a-practitioner', to: 'pages#become_a_practitioner', as: :become_a_practitioner

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

  resources :users, only: [:show] do
    resources :practitioners, only: %i[new create]
    resources :conversations, only: [:create]
    resources :user_health_goals, only: [:create]
  end

  get 'users/:id/sessions', to: 'users#booking', as: :user_sessions
  get 'users/:id/favorites', to: 'users#favorite', as: :user_favorites
  get 'users/:id/notifications', to: 'users#notification', as: :user_notifications

  resources :practitioners, only: %i[index show update destroy] do
    resources :practitioner_specialties, only: [:create]
    resources :practitioner_languages, only: [:create]
    resources :practitioner_social_links, only: [:create]
    resources :favorite_practitioners, only: [:create]
    resources :working_hours, only: [:create]
  end

  get 'practitioners/:id/profile', to: 'practitioners#profile', as: :practitioner_profile
  get 'practitioners/:id/services', to: 'practitioners#service', as: :practitioner_services

  resources :practitioner_specialties, only: [:destroy]

  resources :practitioner_languages, only: [:destroy]

  resources :practitioner_social_links, only: [:destroy]

  resources :user_health_goals, only: [:destroy]

  resources :favorite_practitioners, only: [:destroy]

  resources :working_hours, only: [:destroy]

  resources :languages, only: %i[create destroy]

  resources :specialties, only: %i[create destroy] do
    resources :specialty_health_goals, only: [:create]
  end

  resources :health_goals, only: %i[create destroy]

  resources :services, only: %i[create index show update destroy] do
    resources :sessions, only: [:create]
    resources :favorite_services, only: [:create]
  end

  resources :favorite_services, only: [:destroy]

  resources :sessions, only: %i[show edit update destroy] do
    resources :payments, only: [:new]
    resources :reviews, only: [:create]
  end

  resources :reviews, only: [:destroy]

  resources :notifications, only: %i[update destroy]

  resources :conversations, only: [:show] do
    resources :messages, only: [:create]
  end

  resources :newsletters, only: %i[create destroy]

  get 'newsletters/:id/unsubscribe', to: 'newsletters#unsubscribe', as: :newsletter_unsubscribe

  mount StripeEvent::Engine, at: '/stripe-webhooks'
end
