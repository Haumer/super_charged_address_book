Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :contacts do 
    resources :group_contacts
    resources :notes, except: [ :destroy ]
    resources :contact_tags, except: [ :destroy ]
  end
  resources :notes, only: [ :destroy ]
  resources :groups
  resources :users, only: [ :show ]
  resources :tags

  get "destroy_fake_contacts", to: "users#destroy_fake_contacts"
  get "fake_contact", to: "users#fake_contact"
  get "heatmap", to: "reminders#heatmap"
  resources :reminders do
    resources :contact_reminders
  end
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
