Rails.application.routes.draw do
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

  resources :languages, only: [:create, :destroy]
end
