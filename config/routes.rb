Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  root to:'static_pages#home'

  get "products", to: "products#index"
  get "/products/:slug", to: "products#show"

  get "/profile/purchase", to: "profiles#purchase"
  get "/profile/sale", to: "profiles#sale"
  get "/profile/balance", to: "profiles#balance"
end
