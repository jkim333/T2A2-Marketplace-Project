class ProfilesController < ApplicationController
    before_action  :get_categories

    def purchase
    end

    def sale
    end

    def balance
    end

    private

    def get_categories
        @categories = Category.all[0..3]
      end
end
