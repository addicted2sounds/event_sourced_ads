module Repository
  extend self

  def load(aggregate_class, stream_name)
    events = Event.where(stream_name:).map do |event|
      event.event_type.constantize.new(data: event.data)
    end
    aggregate_class.new(stream_name).tap do |aggregate|
      events.each do |event|
        aggregate.apply_event(event)
      end
    end
  end

  def store(aggregate)
    aggregate.unpublished_events.each do |event|
      event.publish(stream_name: aggregate.id)
    end
  end
end