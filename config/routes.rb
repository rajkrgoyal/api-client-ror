# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'widgets#index'
  resources 'widgets', except: [:show] do
    get :my_widgets, on: :collection, as: :my
  end

  resource :users, only: [:show] do
    resources :widgets, only: [:index]
    collection do
      resource :sessions, only: %i[new create destroy] do
        get :links, on: :collection
      end
      resource :registrations, except: [:destroy]
      resource :passwords, except: [:destroy]
    end
  end
end
