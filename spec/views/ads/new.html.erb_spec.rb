require 'rails_helper'

RSpec.describe "ads/new", type: :view do
  before(:each) do
    assign(:ad, Ad.new(
      title: "MyString",
      body: "MyText",
      status: "MyString"
    ))
  end

  it "renders new ad form" do
    render

    assert_select "form[action=?][method=?]", ads_path, "post" do

      assert_select "input[name=?]", "ad[title]"

      assert_select "textarea[name=?]", "ad[body]"

      assert_select "input[name=?]", "ad[status]"
    end
  end
end
