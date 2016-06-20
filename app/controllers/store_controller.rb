class StoreController < ApplicationController
  
  def index
    if @page_template = PageTemplate.find_by(page: "store_index")
      template = Liquid::Template.parse(@page_template.body)
      @liquid_template = template.render(available_drops)
    else
      @products = Product.published # notice this is the same as the drop you want...
    end
  end

  def product
    @product = Product.friendly.find(params[:id])
    @product_view = ProductView.new(product: @product, cart: @cart)
  end
  

  def help
  end
  
  private
  
  def available_drops
    {
      'products' => ProductsDrop.new(Product.published)
    }
  end
  
end