# frozen_string_literal: true

require "rails_helper"

RSpec.describe Events::AdCreated do
  describe ".publish" do
    subject(:publish) do
      described_class.publish(
        data: {title: "Some title", description: "Some description"},
        stream_name: "123456789",
      )
    end

    it "persists the event in database" do
      expect { publish }.to change { Event.count }.by(1)
      expect(Event.last).to have_attributes(
        event_type: "Events::AdCreated",
        data: {
          "title" => "Some title",
          "description" => "Some description"
        },
        aggregate_id: "123456789"
      )
    end
  end
end
