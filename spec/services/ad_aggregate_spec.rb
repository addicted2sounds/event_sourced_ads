# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdAggregate do
  let(:aggregate) { described_class.new }
  let(:valid_attributes) do
    {title: "Test title", body: "Test description"}
  end

  it "has valid attributes on initialization" do
    expect(aggregate).to have_attributes(
      id: kind_of(String),
      state: :new
    )
  end

  describe "#create_draft" do
    subject(:create_draft) { aggregate.create_draft(**attributes) }

    context "with valid attributes" do
      let(:attributes) { valid_attributes }

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

  describe "#update_content" do
    subject(:update_content) { aggregate.update_content(**new_attributes) }

    let(:aggregate) { described_class.new }
    let(:new_attributes) do
      {title: "Updated title", body: "Updated description"}
    end

    context "when ad is in draft state" do
      before { aggregate.create_draft(**valid_attributes) }

      it "updates ad attributes" do
        update_content
        expect(aggregate).to have_attributes(
          attributes: {
            title: "Updated title",
            body: "Updated description"
          },
          state: :draft
        )
      end
    end

    context "when ad is in published state" do
      before do
        aggregate.create_draft(**valid_attributes)
        aggregate.publish
      end

      it "raises an error" do
        expect { update_content }.to raise_error(described_class::AlreadyPublished)
      end
    end
  end

  describe "#publish" do
    subject(:publish) { aggregate.publish }

    let(:aggregate) { described_class.new }

    context "when ad is in draft state" do
      before { aggregate.create_draft(**valid_attributes) }

      it "updates state to published" do
        publish
        expect(aggregate.state).to eq(:published)
      end
    end

    context "when ad is in published state" do
      before do
        aggregate.create_draft(**valid_attributes)
        aggregate.publish
      end

      it "raises an error" do
        expect { publish }.to raise_error(described_class::AlreadyPublished)
      end
    end
  end
end
