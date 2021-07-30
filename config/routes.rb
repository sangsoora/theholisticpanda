Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: 'registrations', confirmations: 'confirmations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/become-a-practitioner', to: 'pages#become_a_practitioner', as: :become_a_practitioner

  get '/aboutus', to: 'pages#aboutus', as: :aboutus

  get '/faq', to: 'pages#faq', as: :faq

  get '/terms', to: 'pages#terms', as: :terms

  get '/privacy', to: 'pages#privacy', as: :privacy

  get '/cookie', to: 'pages#cookie', as: :cookie

  get '/practitioners/filter', to: 'practitioners#filter', as: :practitioner_filter

  get '/specialties/filter', to: 'specialties#filter', as: :specialty_filter

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

  resources :users, only: [:show] do
    resources :practitioners, only: %i[new create]
    resources :conversations, only: [:create]
    resources :user_health_goals, only: [:create]
    resources :referred_users, only: [:create]
    resources :payment_methods, only: [:create]
    resources :user_promos, only: [:create]
  end

  resources :payment_methods, only: %i[update destroy]

  get '/payment', to: 'payments#payment', as: :user_payment

  get '/sessions', to: 'users#booking', as: :user_sessions
  get '/practitioner_sessions', to: 'practitioners#booking', as: :practitioner_sessions
  get '/favourites', to: 'users#favorite', as: :user_favorites
  get '/notifications', to: 'users#notification', as: :user_notifications

  resources :practitioners, only: %i[index show update destroy] do
    resources :practitioner_specialties, only: [:create]
    resources :practitioner_languages, only: [:create]
    resources :practitioner_social_links, only: [:create]
    resources :practitioner_certifications, only: [:create]
    resources :practitioner_memberships, only: [:create]
    resources :favorite_practitioners, only: [:create]
    resources :working_hours, only: [:create]
    resources :practitioner_payments, only: [:new]
  end

  get '/profile', to: 'practitioners#profile', as: :practitioner_profile
  get '/my_services', to: 'practitioners#service', as: :practitioner_services
  get '/discovery_call/:id', to: 'practitioners#discovery_call', as: :practitioner_discovery_call

  resources :practitioner_specialties, only: [:destroy]

  resources :practitioner_languages, only: [:destroy]

  resources :practitioner_social_links, only: [:destroy]

  resources :practitioner_certifications, only: [:destroy]

  resources :practitioner_memberships, only: [:destroy]

  resources :user_health_goals, only: [:destroy]

  resources :favorite_practitioners, only: [:destroy]

  resources :working_hours, only: %i[update destroy]

  resources :languages, only: %i[create destroy]

  resources :specialty_categories, only: %i[create destroy]

  resources :specialties, only: %i[show create destroy]

  resources :health_goals, only: %i[create destroy]

  resources :services, only: %i[create index show update destroy] do
    resources :sessions, only: [:create]
    resources :favorite_services, only: [:create]
    resources :service_health_goals, only: [:create]
  end

  resources :service_health_goals, only: [:destroy]

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

  resources :events, only: %i[index create show update destroy] do
    resources :event_attendees, only: [:create]
  end

  resources :event_attendees, only: [:destroy]

  resources :tax_rates, only: %i[create update destroy]

  get '/blog', to: 'posts#index', as: :posts

  get '/blog/:id', to: 'posts#show', as: :post

  resources :posts, only: %i[new create edit update destroy]

  resources :post_categories, only: [:show]

  resources :post_sub_categories, only: [:show]

  resources :post_authors, only: [:show]

  mount StripeEvent::Engine, at: '/stripe-webhooks'

  # post '/background_check/modo_webhooks', to: 'background_check#modo_webhooks'

  post '/background_check/certn_webhooks', to: 'background_check#certn_webhooks'
end
