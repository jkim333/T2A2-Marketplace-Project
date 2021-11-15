class StaticPagesController < ApplicationController
  def home
    @categories = Category.all[0..3]
    @products = Product.where(listed: true)[0..7]
  end
end
