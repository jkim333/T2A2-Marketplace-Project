require 'json'

class TransactionsController < ApplicationController
    def create
        cartItems = JSON.parse(params[:cartItems])
        products = []

        ActiveRecord::Base.transaction do
            cartItems.each do |cartItem|
                product = Product.find(cartItem["productId"])
                seller = product.user
                buyer = current_user
                quantity = cartItem["quantity"]

                if seller == buyer
                    redirect_to profile_purchase_path
                    flash[:alert_purchase] = "You can't buy your own product."
                    return
                end

                if quantity > product.stock
                    redirect_to profile_purchase_path
                    flash[:alert_purchase] = "Your quantity can't be more than the available number of items."
                    return
                end

                price = product.price
                transaction = Transaction.new
                transaction.seller = seller
                transaction.buyer = buyer
                transaction.product = product
                transaction.quantity = quantity
                transaction.price = price
                transaction.save!

                product.stock = product.stock - quantity
                product.save!

                seller.balance = quantity * price
                seller.save!

                products << product.title
            end
        end
        flash[:success_purchase] = "You've successfully purchased the following items: #{products.join(", ")}"
        redirect_to profile_purchase_path
    end
end
