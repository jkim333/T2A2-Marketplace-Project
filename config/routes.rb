Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  root to:'products#index'

  get "/products/:slug", to: "products#show"
end
