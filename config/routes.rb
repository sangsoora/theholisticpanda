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
  end

  get 'users/:id/sessions', to: 'users#booking', as: :user_sessions

  resources :practitioners, only: [:index, :show, :edit, :update, :destroy] do
    resources :practitioner_languages, only: [:create]
  end

  resources :practitioner_languages, only: [:destroy]

  resources :languages, only: [:destroy]

  resources :practitioner_specialties, only: [:destroy] do
    resources :services, only: [:create]
  end

  resources :specialties, only: [:destroy]

  resources :services, only: [:show, :update, :destroy] do
    resources :sessions, only: [:create]
  end

  resources :sessions, only: [:show, :edit, :update, :destroy] do
    resources :payments, only: [:new]
  end

  mount StripeEvent::Engine, at: '/stripe-webhooks'
end
