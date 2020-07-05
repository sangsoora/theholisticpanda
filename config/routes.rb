Rails.application.routes.draw do
  get 'sessions/show'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/edit'
  get 'sessions/update'
  get 'sessions/destroy'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  resources :users, only: [:show] do
    resources :practitioners, only: [:create]
  end

  resources :practitioners, only: [:show, :edit, :update, :destroy] do
    resources :practitioner_languages, only: [:create]
  end

  resources :practitioner_languages, only: [:destroy]

  resources :languages, only: [:destroy]

  resources :practitioner_specialties, only: [:show, :destroy] do
    resources :sessions, only: [:create]
  end

  resources :specialties, only: [:destroy]

  resources :sessions, only: [:show, :edit, :update, :destroy]
end
