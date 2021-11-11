class ProductsController < ApplicationController
  before_action  :get_categories

  def index
    category_slug = params[:category]
    min_price = params[:min_price].nil? ? nil : params[:min_price].to_f * 100
    max_price = params[:max_price].nil? ? nil : params[:max_price].to_f * 100

    if category_slug == 'all'
      @category = 'all'

      if min_price && max_price
        @products = Product.where("price >= ?", min_price).where("price <= ?", max_price)
      elsif min_price
        @products = Product.where("price >= ?", min_price)
      elsif max_price
        @products = Product.where("price <= ?", max_price)
      else
        @products = Product.all
      end

      @category_counts = Product.group(:category_id).count
      @min_price = min_price.nil? ? nil : min_price /100
      @max_price = max_price.nil? ? nil : max_price /100
    else
      category = Category.find_by slug: category_slug

      if !category
        redirect_to products_path(category: "all")
        return
      else
        @category = category

        if min_price && max_price
          @products = category.products.where("price >= ?", min_price).where("price <= ?", max_price)
        elsif min_price
          @products = category.products.where("price >= ?", min_price)
        elsif max_price
          @products = category.products.where("price <= ?", max_price)
        else
          @products = category.products
        end

        @category_counts = Product.group(:category_id).count
        @min_price = min_price.nil? ? nil : min_price /100
      @max_price = max_price.nil? ? nil : max_price /100
      end
    end
  end

  def show
    @product = Product.friendly.find(params[:slug])
  end

  private

  def get_categories
    @categories = Category.all
  end
end
