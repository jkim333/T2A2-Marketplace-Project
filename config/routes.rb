Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  root to:'static_pages#home'

  get "/:category/products", to: "products#index", as: "products"
  get "/products/new", to: "products#new"
  post "/products/new", to: "products#create"
  get "/:category/products/:slug", to: "products#show", as: "products_show"
  get "/products/:id", to: "products#show_json"

  get "/profile/purchase", to: "profile#purchase"
  get "/profile/sale", to: "profile#sale"
  get "/profile/balance", to: "profile#balance"
  get "/profile/cart", to: "profile#cart"
  get "/profile/ads", to: "profile#ads"

  patch "/profile/balance/bank_detail", to: "profile#edit_bank_detail", as: "edit_bank_detail"
  patch "/profile/balance/balance", to: "profile#edit_balance", as: "edit_balance"

  post "/profile/transaction", to: "profile#create_transaction", as: "create_transaction"
end
