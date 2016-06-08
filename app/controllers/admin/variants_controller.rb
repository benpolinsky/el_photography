class Admin::VariantsController < AdminController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def destroy
    @variant = @product.variants.find(params[:id])
    @variant.destroy
    redirect_to [:edit, :admin, @product], notice: "Variant Deleted"
  end
  
  private
  
  def set_product
    @product = Product.friendly.find(params[:product_id])
  end
end
