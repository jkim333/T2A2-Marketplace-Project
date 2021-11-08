Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  root to:'products#index'

  get "/products/:slug", to: "products#show"

  get "/profile/purchase", to: "profiles#purchase"
  get "/profile/sale", to: "profiles#sale"
  get "/profile/balance", to: "profiles#balance"
end
