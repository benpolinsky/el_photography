class Admin::ProductsController < AdminController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.rank(:row_order)
  end

  def show
  end

  def new
    @photos = Photo.all
    @product = Product.new
  end

  def edit
    @photos = Photo.all
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to [:edit, :admin, @product], notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_from_photo
    @product = Product.create_from_photo(params[:photo_id])
      respond_to do |format|
        if @product.valid?
          format.html { redirect_to [:edit, :admin, @product], notice: 'Product was successfully created.' }
          format.json { render :show, status: :created, location: @product }
        else
          @resource = @product
          format.html { redirect_to admin_photo_path(params[:photo_id]), notice: error_list_for(@product) }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end 
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [:edit, :admin, @product], notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        @resource = @product
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  
  def update_row_order
    @product = Product.find(params[:item][:item_id])
    @product.row_order_position = params[:item][:row_order_position]
    @product.save
    head :created
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :temporary_slug, :description, :price, :published_at, :using_inventory,
    :quantity, :weight_in_oz, :row_order, :shipping_base, :slug, :additional_shipping_per_item,
    :deleted_at, :international_shipping_base, :sizes_list, :photo_id, :variants_attributes => [:price, :quantity, :row_order, :shipping_base, :slug, :additional_shipping_per_item, :deleted_at, :id, :using_inventory])
  end
end
