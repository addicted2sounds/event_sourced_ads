# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdAggregate do
  let(:aggregate) { described_class.new }

  it "has valid attributes on initialization" do
    expect(aggregate).to have_attributes(
      id: kind_of(String),
      state: :new
    )
  end

  describe "#create_draft" do
    subject(:create_draft) { aggregate.create_draft(**attributes) }

    context "with valid attributes" do
      let(:attributes) do
        {title: "Test title", body: "Test description"}
      end

      it "updates attributes and state" do
        create_draft
        expect(aggregate).to have_attributes(
          attributes: {
            title: "Test title",
            body: "Test description"
          },
          state: :draft
        )
      end
    end
  end
end
