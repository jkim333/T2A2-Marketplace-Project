Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  root to:'static_pages#home'

  get "/:category/products", to: "products#index", as: "products"
  get "products/new", to: "products#new"
  get "/:category/products/:slug", to: "products#show", as: "products_show"

  get "/profile/purchase", to: "profiles#purchase"
  get "/profile/sale", to: "profiles#sale"
  get "/profile/balance", to: "profiles#balance"
  get "/profile/cart", to: "profiles#cart"
  get "/profile/ads", to: "profiles#ads"
end
