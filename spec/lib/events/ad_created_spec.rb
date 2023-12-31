# frozen_string_literal: true

require "rails_helper"

RSpec.describe Events::AdCreated do
  before { allow(ApplicationEventListener).to receive(:call) }

  describe ".publish" do
    subject(:publish) do
      described_class.publish(
        data: {ad_id:, title: "Some title", body: "Some description"},
        stream_name: "123456789",
      )
    end

    let(:ad_id) { SecureRandom.uuid }

    it "persists the event in database" do
      expect { publish }.to change { Event.count }.by(1)
      expect(Event.last).to have_attributes(
        event_type: "Events::AdCreated",
        data: {
          "ad_id" => ad_id,
          "title" => "Some title",
          "body" => "Some description"
        },
        stream_name: "123456789"
      )
    end
  end
end
