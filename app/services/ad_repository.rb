module AdRepository
  extend self

  def load(stream_name)
    events = Event.where(stream_name:).map do |event|
      event.event_type.constantize.new(data: event.data)
    end
    AdAggregate.new(stream_name).tap do |aggregate|
      events.each do |event|
        aggregate.send("apply", event)
      end
    end
  end

  def store(aggregate)
    aggregate.unpublished_events.each do |event|
      event.publish(stream_name: aggregate.id)
    end
  end
end
