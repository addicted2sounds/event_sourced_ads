require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/ads", type: :request do
  let(:valid_attributes) do
    { title: "title", body: "body" }
  end

  describe "POST /create" do
    let(:do_request) { post "/ads", params: { ad: valid_attributes } }

    context "with valid parameters" do
      it "creates a new Ad" do
        expect { do_request }
          .to change { Event.count }.by(1)
          .and change { Ad.count }.by(1)
        expect(Event.last).to have_attributes(
          event_type: "Events::AdCreated",
          data: valid_attributes.stringify_keys
        )
        expect(Ad.last).to have_attributes(
          **valid_attributes, status: "draft"
        )
      end
    end
  end
end
