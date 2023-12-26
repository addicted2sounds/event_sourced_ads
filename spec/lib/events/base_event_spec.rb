# frozen_string_literal: true

require "rails_helper"

RSpec.describe Events::BaseEvent do
  before do
    stub_const("FakeEvent", fake_event)
  end

  describe ".publish" do
    context "when schema on a base event is undefined" do
      subject(:publish) { FakeEvent.publish }

      let(:fake_event) do
        Class.new(described_class)
      end

      it "raises error regarding missing contract" do
        expect { publish }.to raise_error(
          described_class::MissingContract, "Contract needs to be implemented"
        )
      end
    end

    context "when schema on a base event is defined" do
      let(:fake_event) do
        Class.new(described_class) do
          schema do
            Dry::Schema.Params do
              required(:name).filled(:string)
            end
          end
        end
      end

      context "with valid arguments" do
        context "when have data attribute" do
          subject(:publish) { FakeEvent.publish(data: {name: "whatever"}, stream_name: "123123") }

          it "persists an event record" do
            expect { publish }.to change { Event.count }.by(1)
            expect(Event.last).to have_attributes(
              event_type: "FakeEvent",
              data: {"name" => "whatever"},
              stream_name: "123123"
            )
          end

          it "sends a notification" do
            allow(ActiveSupport::Notifications).to receive(:instrument)
            publish
            expect(ActiveSupport::Notifications).to have_received(:instrument).with(
              "FakeEvent", data: {name: "whatever"}, stream_name: "123123"
            )
          end
        end
      end

      context "with invalid arguments" do
        subject(:publish) { FakeEvent.publish(data: {unknown_key: "whatever"}, stream_name: "123") }

        it "raise an error" do
          expect { publish }.to raise_error(described_class::InvalidAttributes)
        end
      end
    end
  end
end
