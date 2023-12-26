require 'rails_helper'

RSpec.describe "ads/index", type: :view do
  before(:each) do
    assign(:ads, [
      Ad.create!(
        title: "Title",
        body: "MyText",
        status: "Status"
      ),
      Ad.create!(
        title: "Title",
        body: "MyText",
        status: "Status"
      )
    ])
  end

  it "renders a list of ads" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end
