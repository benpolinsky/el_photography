require 'rails_helper'

RSpec.describe "admin/tags/new", type: :view do
  before(:each) do
    assign(:admin_tag, Admin::Tag.new())
  end

  it "renders new admin_tag form" do
    render

    assert_select "form[action=?][method=?]", tags_path, "post" do
    end
  end
end
