class ProfileController < ApplicationController
    before_action  :get_categories
    before_action :authenticate_user!, except: [:cart]

    def purchase
      @purchases = Transaction.where(buyer_id: current_user.id).paginate(page: params[:page])
    end

    def sale
      @sales = Transaction.where(seller_id: current_user.id).paginate(page: params[:page])
    end

    def create_transaction
      # CREATE CHECKOUT and create purchase and sale history
      p "TODO"
    end

    def balance(bank_detail=nil)
      if bank_detail.nil?
        @bank_detail = current_user.bank_detail
      else
        @bank_detail = bank_detail
      end
    end

    def edit_bank_detail
      bank_detail = current_user.bank_detail
      bank_detail.name = params[:bank_detail][:name]
      bank_detail.account_number = params[:bank_detail][:account_number]
      bank_detail.bsb = params[:bank_detail][:bsb]
      is_saved = bank_detail.save

      if !is_saved
        flash[:alert_bank_detail] = bank_detail.errors.full_messages
      else
        flash[:success_bank_detail] = "Your details have been updated."
      end

      redirect_to profile_balance_path
    end

    def edit_balance
      dollars = params[:dollars].to_f
      cents = params[:cents].to_f

      total = dollars * 100 + cents

      if current_user.bank_detail.name == "" || current_user.bank_detail.account_number == "" || current_user.bank_detail.bsb == ""
        flash[:alert_balance] = "Please submit your bank details first."
      elsif dollars < 0 || cents < 0
        flash[:alert_balance] = "The amount you transfer can't be negative."
      elsif dollars == 0 && cents == 0
        flash[:alert_balance] = "You can't transfer $0.00."
      elsif cents >= 100
        flash[:alert_balance] = "The amount you entered for cents should be less than 100."
      elsif current_user.balance < total
        flash[:alert_balance] = "The amount you transfer can't be greater than your balance."
      else
        current_user.balance = current_user.balance - total
        current_user.save
        flash[:success_balance] = "You've successfully transferred #{dollars.to_i} #{"dollar".pluralize(dollars.to_i)} #{cents.to_i} #{"cent".pluralize(cents.to_i)}"
      end

      redirect_to profile_balance_path
    end

    def ads
      @products = Product.where("user_id = '#{current_user.id}'").paginate(page: params[:page])
    end

    def cart
    end

    private

    def get_categories
      @categories = Category.all
    end
end
