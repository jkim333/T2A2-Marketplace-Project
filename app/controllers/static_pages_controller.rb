class StaticPagesController < ApplicationController
  def home
    @categories = Category.all[0..3]
    @products = Product.all[0..7]
  end
end
