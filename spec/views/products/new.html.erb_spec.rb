require 'rails_helper'

RSpec.describe "products/new", type: :view do
  before(:each) do
    assign(:product, Product.new(
      :name => "MyString",
      :description => "MyText",
      :price_cents => 1,
      :price_cents_currency => "MyString",
      :quantity => 1,
      :weight_in_oz => 1,
      :row_order => 1,
      :photo => nil,
      :shipping_cents => 1,
      :shipping_currency => "MyString",
      :slug => "MyString",
      :state => 1,
      :uid => "MyString",
      :international_shipping_cents => 1,
      :international_shipping_currency => "MyString"
    ))
  end

  it "renders new product form" do
    render

    assert_select "form[action=?][method=?]", products_path, "post" do

      assert_select "input#product_name[name=?]", "product[name]"

      assert_select "textarea#product_description[name=?]", "product[description]"

      assert_select "input#product_price_cents[name=?]", "product[price_cents]"

      assert_select "input#product_price_cents_currency[name=?]", "product[price_cents_currency]"

      assert_select "input#product_quantity[name=?]", "product[quantity]"

      assert_select "input#product_weight_in_oz[name=?]", "product[weight_in_oz]"

      assert_select "input#product_row_order[name=?]", "product[row_order]"

      assert_select "input#product_photo_id[name=?]", "product[photo_id]"

      assert_select "input#product_shipping_cents[name=?]", "product[shipping_cents]"

      assert_select "input#product_shipping_currency[name=?]", "product[shipping_currency]"

      assert_select "input#product_slug[name=?]", "product[slug]"

      assert_select "input#product_state[name=?]", "product[state]"

      assert_select "input#product_uid[name=?]", "product[uid]"

      assert_select "input#product_international_shipping_cents[name=?]", "product[international_shipping_cents]"

      assert_select "input#product_international_shipping_currency[name=?]", "product[international_shipping_currency]"
    end
  end
end
