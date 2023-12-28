# frozen_string_literal: true

require "rails_helper"

RSpec.describe Events::AdRemoved do
  before { allow(ApplicationEventListener).to receive(:call) }

  describe ".publish" do
    subject(:publish) do
      described_class.publish(
        data: {
          ad_id:,
          reason: "Outmoded"
        },
        stream_name: ad_id
      )
    end
    let(:ad_id) { SecureRandom.uuid }

    it "persists the event in database" do
      expect { publish }.to change { Event.count }.by(1)
      expect(Event.last).to have_attributes(
        event_type: "Events::AdRemoved",
        data: {
          "ad_id" => ad_id,
          "reason" => "Outmoded"
        },
        stream_name: ad_id
      )
    end
  end
end
