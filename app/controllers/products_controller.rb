class ProductsController < ApplicationController
  def index
  end

  def show
    @product = Product.friendly.find(params[:slug])
  end
end
