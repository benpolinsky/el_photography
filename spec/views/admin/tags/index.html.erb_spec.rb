require 'rails_helper'

RSpec.describe "admin/tags/index", type: :view do
  before(:each) do
    assign(:tags, [
      Admin::Tag.create!(),
      Admin::Tag.create!()
    ])
  end

  it "renders a list of admin/tags" do
    render
  end
end
