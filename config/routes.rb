Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :contacts do 
    resources :group_contacts
    resources :notes
  end
  resources :groups
  resources :users, only: [ :show ]

  get "heatmap", to: "reminders#heatmap"
  resources :reminders do
    resources :contact_reminders
  end
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
