class ProductsController < ApplicationController
  before_action  :get_categories

  def index
    category_slug = params[:category]
    min_price = params[:min_price].nil? ? nil : params[:min_price].to_f * 100
    max_price = params[:max_price].nil? ? nil : params[:max_price].to_f * 100
    @search = params[:search]

    if category_slug == 'all'
      @category = 'all'

      if min_price && max_price
        @products = Product.where("price >= ?", min_price).where("price <= ?", max_price).paginate(page: params[:page])
      elsif min_price
        @products = Product.where("price >= ?", min_price).paginate(page: params[:page])
      elsif max_price
        @products = Product.where("price <= ?", max_price).paginate(page: params[:page])
      else
        @products = Product.all.paginate(page: params[:page])
      end

      if @search
        @products = @products.where("title ilike ?", "%#{@search}%").paginate(page: params[:page])
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
          @products = category.products.where("price >= ?", min_price).where("price <= ?", max_price).paginate(page: params[:page])
        elsif min_price
          @products = category.products.where("price >= ?", min_price).paginate(page: params[:page])
        elsif max_price
          @products = category.products.where("price <= ?", max_price).paginate(page: params[:page])
        else
          @products = category.products.paginate(page: params[:page])
        end

        if @search
          @products = @products.where("title ilike ?", "%#{@search}%").paginate(page: params[:page])
        end

        @category_counts = Product.group(:category_id).count
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
        @product = Product.friendly.find(params[:slug])
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
          @product = @category.products.friendly.find(params[:slug])
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
      product = Product.find(id)
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

    flash[:success_ad] = "You've listed a new add for a product titled '#{product.title}'"
    redirect_to profile_ads_path
  end

  private

  def get_categories
    @categories = Category.all
  end
end
