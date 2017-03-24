Rails.application.routes.draw do
  root 'welcome#index'

  namespace :api, defaults: { format: :json } do
    resources :users, only: [:index, :create, :destroy] do
      resources :lists, only: [:create, :destroy, :update]
    end

    resources :lists, only: [] do
      resources :items, only: [:create]
    end

    resources :items, only: [:destroy, :update]
  end
end
