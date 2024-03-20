# frozen_string_literal: true

require "rails_helper"

RSpec.describe Repository do
  describe '.load' do
    subject(:load) { described_class.load(aggregate_class, stream_name) }

    let(:aggregate_class) { AdAggregate }
    let(:stream_name) { SecureRandom.uuid }

    context "without events" do
      it "loads new aggregate" do
        expect(load).to be_instance_of(aggregate_class).and have_attributes(
          id: stream_name,
          state: :new
        )
      end
    end

    context "with existing events" do
      context "when applying AdCreated event" do
        before do
          Event.create(
            event_type: "Events::AdCreated", stream_name:,
            data: {ad_id: stream_name, title: "title", body: "body"}
          )
        end

        it "applies event to aggregate" do
          expect(load).to be_a(AdAggregate).and have_attributes(
            id: stream_name,
            state: :draft,
            attributes: {
              title: "title",
              body: "body"
            }
          )
        end

        context "when applying AdPublished" do
          before do
            Event.create(
              event_type: "Events::AdPublished", stream_name:,
              data: {ad_id: stream_name, remote_id: "xosfjoj"}
            )
          end

          it "applies event to aggregate" do
            expect(load).to be_a(AdAggregate).and have_attributes(
              id: stream_name,
              state: :published,
              attributes: {
                title: "title",
                body: "body"
              }
            )
          end
        end
      end
    end
  end

  describe '.store' do
    subject(:store) { described_class.store(aggregate) }

    context "with unpublished events" do
      let(:aggregate) do
        instance_double(AdAggregate, id: stream_name, unpublished_events: [event])
      end
      let(:stream_name) { SecureRandom.uuid }
      let(:event) do
        Events::AdCreated.new(data: {ad_id: stream_name, title: "title", body: "body"})
      end

      it "publishes pending events" do
        expect { store }.to change { Event.count }.by(1)
        expect(Event.last).to have_attributes(
          stream_name:,
          event_type: "Events::AdCreated",
          data: {
            "ad_id" => stream_name,
            "title" => "title",
            "body" => "body"
          }
        )
      end
    end
  end
end
