class ApplicationEventListener
  def self.call(event)
    public_send(
      "apply_#{event.name.demodulize.underscore}", **event.payload
    )
  end
end
