class StoreController < ApplicationController
  prepend_before_action :redirect_to_coming_soon
  
  def index
    if @page_template = PageTemplate.find_by(page: "store_index")
      template = Liquid::Template.parse(@page_template.body)
      @liquid_template = template.render(available_drops)
    else
      @products = Product.published # notice this is the same as the drop you want...
    end
  end

  def product
    @product = Product.published.friendly.find_by(id: params[:id])
    redirect_back(fallback_location: store_path) and return unless @product
    @product_view = ProductView.new(product: @product, cart: @cart)
  end
  

  def help
  end
  
  private
  def redirect_to_coming_soon
    if !current_user
      redirect_to coming_soon_path
    end
  end
  
  def available_drops
    {
      'products' => ProductsDrop.new(Product.published)
    }
  end
  
end