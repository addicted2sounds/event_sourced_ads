class AdAggregate
  attr_reader :id, :attributes, :state

  AlreadyPublished = Class.new(StandardError)

  def initialize(id = nil)
    @id = id || SecureRandom.uuid
    @state = :new
  end

  def create_draft(title:, body:)
    apply Events::AdCreated.new(data: {ad_id: id, title:, body:})
  end

  def update_content(title:, body:)
    raise AlreadyPublished if state == :published

    apply Events::AdModified.new(data: {ad_id: id, title:, body:})
  end

  def publish
    raise AlreadyPublished if state == :published

    apply Events::AdPublished.new(data: {ad_id: id})
  end

  def unpublished_events
    @unpublished_events ||= []
  end

  def apply_event(event)
    send("apply_#{event.class.name.demodulize.underscore}", event)
  end

  private

  def apply(event)
    unpublished_events << event
    apply_event(event)
  end

  def apply_ad_created(event)
    @state = :draft
    @attributes = event.data.symbolize_keys.slice(:title, :body)
  end

  def apply_ad_modified(event)
    @attributes = event.data.slice(:title, :body)
  end

  def apply_ad_published(event)
    @state = :published
  end
end
