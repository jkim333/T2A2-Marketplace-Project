class StaticPagesController < ApplicationController
  def home
    @categories = Category.all[0..3]
  end
end
