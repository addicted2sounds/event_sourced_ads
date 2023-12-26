require 'rails_helper'

RSpec.describe "ads/show", type: :view do
  before(:each) do
    assign(:ad, Ad.create!(
      title: "Title",
      body: "MyText",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
  end
end
