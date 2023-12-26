# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdEventListener do
  describe ".apply_ad_created" do
    subject(:publish_event) do
      ActiveSupport::Notifications.instrument(
        "Events::AdCreated",
        data: {title: "title", body: "body"},
        stream_name: SecureRandom.uuid
      )
    end

    it "creates new Ad record" do
      expect { publish_event }.to change { Ad.count }.by(1)
      expect(Ad.last).to have_attributes(
        title: "title",
        body: "body"
      )
    end
  end
end
