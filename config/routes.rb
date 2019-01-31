Rails.application.routes.draw do
  root "home#index"

  get '/auth/github/callback', to: 'sessions#create'

  get '/dashboard', to: 'dashboard#show'
end
