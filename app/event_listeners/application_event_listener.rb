class ApplicationEventListener
  def self.call(event)
    send(
      "apply_#{event.name.demodulize.underscore}", **event.payload
    )
  end
end
