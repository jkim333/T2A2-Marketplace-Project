class ProductsController < ApplicationController
  before_action  :get_categories

  def index
  end

  def show
    @product = Product.friendly.find(params[:slug])
  end

  private

  def get_categories
    @categories = Category.all[0..3]
  end
end
