require 'rails_helper'

RSpec.describe "products/index", type: :view do
  before(:each) do
    assign(:products, [
      Product.create!(
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
      ),
      Product.create!(
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
      )
    ])
  end

  it "renders a list of products" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Price Cents Currency".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "Shipping Currency".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => "International Shipping Currency".to_s, :count => 2
  end
end
