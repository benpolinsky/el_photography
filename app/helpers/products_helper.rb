module ProductsHelper
  def list_variants_by_keys(product)
    options_for_select(product.variants.with_quantity.map do |variant|
      [
        variant.name, variant.id, {
        'data-unique-key' => variant.unique_key, 
        'data-quantity' => variant.available_quantity,
        'data-price' => variant.price.format,
        'data-image' => variant.primary_image(:main)
        }
      ]
    end
    )
  end
end
