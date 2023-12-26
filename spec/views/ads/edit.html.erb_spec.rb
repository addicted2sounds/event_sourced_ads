require 'rails_helper'

RSpec.describe "ads/edit", type: :view do
  let(:ad) {
    Ad.create!(
      title: "MyString",
      body: "MyText",
      status: "MyString"
    )
  }

  before(:each) do
    assign(:ad, ad)
  end

  it "renders the edit ad form" do
    render

    assert_select "form[action=?][method=?]", ad_path(ad), "post" do

      assert_select "input[name=?]", "ad[title]"

      assert_select "textarea[name=?]", "ad[body]"

      assert_select "input[name=?]", "ad[status]"
    end
  end
end
