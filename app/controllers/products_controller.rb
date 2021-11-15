class ProductsController < ApplicationController
  before_action  :get_categories
  before_action :authenticate_user!, only: [:create, :new, :delist, :relist, :edit]

  def index
    category_slug = params[:category]
    min_price = params[:min_price].nil? ? nil : params[:min_price].to_f * 100
    max_price = params[:max_price].nil? ? nil : params[:max_price].to_f * 100
    @search = params[:search]

    if category_slug == 'all'
      @category = 'all'

      if min_price && max_price
        @products = Product.where("price >= ?", min_price).where("price <= ?", max_price).where(listed: true).paginate(page: params[:page])
      elsif min_price
        @products = Product.where("price >= ?", min_price).where(listed: true).paginate(page: params[:page])
      elsif max_price
        @products = Product.where("price <= ?", max_price).where(listed: true).paginate(page: params[:page])
      else
        @products = Product.where(listed: true).paginate(page: params[:page])
      end

      if @search
        @products = @products.where(listed: true).where("title ilike ?", "%#{@search}%").paginate(page: params[:page])
      end

      @category_counts = Product.where(listed: true).group(:category_id).count
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
          @products = category.products.where("price >= ?", min_price).where("price <= ?", max_price).where(listed: true).paginate(page: params[:page])
        elsif min_price
          @products = category.products.where("price >= ?", min_price).where(listed: true).paginate(page: params[:page])
        elsif max_price
          @products = category.products.where("price <= ?", max_price).where(listed: true).paginate(page: params[:page])
        else
          @products = category.products.where(listed: true).paginate(page: params[:page])
        end

        if @search
          @products = @products.where("title ilike ?", "%#{@search}%").where(listed: true).paginate(page: params[:page])
        end

        @category_counts = Product.where(listed: true).group(:category_id).count
        @min_price = min_price.nil? ? nil : min_price /100
        @max_price = max_price.nil? ? nil : max_price /100
      end
    end
  end

  def show
    category_slug = params[:category]

    if category_slug == 'all'
      @category = 'all'

      begin
        @product = Product.where(listed: true).friendly.find(params[:slug])
      rescue ActiveRecord::RecordNotFound
        @product = nil
        @slug = params[:slug]
      end
    else
      category = Category.find_by slug: category_slug

      if !category
        redirect_to products_show_path(category: "all", slug: params[:slug])
        return
      else
        @category = category

        begin
          @product = @category.products.where(listed: true).friendly.find(params[:slug])
        rescue ActiveRecord::RecordNotFound
          @product = nil
          @slug = params[:slug]
        end
      end
    end
  end

  def show_json
    id = params[:id].to_i
    
    begin
      product = Product.where(listed: true).find(id)
      product_image = url_for(product.product_images.first.image)
      product = product.as_json
      product[:image] = product_image
    rescue ActiveRecord::RecordNotFound
      product = nil
    end

    render json: product
  end

  def create
    begin
      category = Category.friendly.find(params[:category])
    rescue ActiveRecord::RecordNotFound
      flash[:alert_ad] = ["Invalid category was provided"]
      redirect_to products_new_path
      return
    end

    if params[:product_images].nil? || params[:product_images].length > 3
      flash[:alert_ad] = ["You need to provide between 1 and 3 images."]
      redirect_to products_new_path
      return
    end

    product = Product.new
    ActiveRecord::Base.transaction do
      product.title = params[:title]
      product.description = params[:description]
      product.price = params[:price].to_i
      product.stock = params[:stock].to_i
      product.category_id = category.id
      product.user_id = current_user.id
      product.save

      if product.invalid?
        flash[:alert_ad] = product.errors.full_messages
        redirect_to products_new_path
        return
      end

      params[:product_images].each do |product_image_param|
        product_image = ProductImage.new
        product_image.image.attach(product_image_param)
        product_image.product_id = product.id
        product_image.save
      end
    end

    flash[:success_ad] = "You've listed a new Ad for a product titled '#{product.title}'."
    redirect_to profile_ads_path
  end

  def new
  end

  def delist
    product = Product.friendly.find(params[:slug])
    if product.user == current_user
      if product.listed
        product.listed = false
        product.save
        flash[:success_ad] = "You've delisted an Ad for a product titled '#{product.title}'."
      else
        flash[:alert_ad] = "Your Ad for a product titled '#{product.title}' is already delisted."
      end
    else
      flash[:alert_ad] = "Your do not have permission to delist an Add for a product titled '#{product.title}'."
    end
    redirect_to profile_ads_path
  end

  def relist
    product = Product.friendly.find(params[:slug])
    if product.user == current_user
      if !product.listed
        product.listed = true
        product.save
        flash[:success_ad] = "You've relisted an Ad for a product titled '#{product.title}'."
      else
        flash[:alert_ad] = "Your Ad for a product titled '#{product.title}' is already listed."
      end
    else
      flash[:alert_ad] = "Your do not have permission to delist an Add for a product titled '#{product.title}'."
    end
    redirect_to profile_ads_path
  end

  private

  def get_categories
    @categories = Category.all
  end
end
