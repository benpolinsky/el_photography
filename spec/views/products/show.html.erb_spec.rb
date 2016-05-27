require 'rails_helper'

RSpec.describe "products/show", type: :view do
  before(:each) do
    @product = assign(:product, Product.create!(
      :name => "Name",
      :description => "MyText",
      :price_cents => 2,
      :price_cents_currency => "Price Cents Currency",
      :quantity => 3,
      :weight_in_oz => 4,
      :row_order => 5,
      :photo => nil,
      :shipping_cents => 6,
      :shipping_currency => "Shipping Currency",
      :slug => "Slug",
      :state => 7,
      :uid => "Uid",
      :international_shipping_cents => 8,
      :international_shipping_currency => "International Shipping Currency"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Price Cents Currency/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(//)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/Shipping Currency/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/Uid/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/International Shipping Currency/)
  end
end
