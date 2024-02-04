class AdAggregate
  attr_reader :id, :attributes, :state

  def initialize(id = nil)
    @id = id || SecureRandom.uuid
    @state = :new
  end

  def create_draft(title:, body:)
    apply Events::AdCreated.new(data: {ad_id: id, title:, body:})
  end

  def unpublished_events
    @unpublished_events ||= []
  end

  private

  def apply(event)
    unpublished_events << event
    apply_event(event)
  end

  def apply_event(event)
    send("apply_#{event.class.name.demodulize.underscore}", event)
  end

  def apply_ad_created(event)
    @state = :draft
    @attributes = event.data.slice(:title, :body)
  end
end
