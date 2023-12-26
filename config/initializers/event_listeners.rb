Rails.application.config.after_initialize do
  {
    AdEventListener: [
      Events::AdCreated,
    ]
  }.each do |listener, events|
    events.each { |event| ActiveSupport::Notifications.subscribe(event.to_s, listener.to_s.constantize) }
  end
end
