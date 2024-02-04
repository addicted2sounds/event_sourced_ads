class AdEventListener < ApplicationEventListener
  class << self
    def apply_ad_created(data:, stream_name:)
      Ad.create!(id: stream_name, **data.slice(:title, :body))
    end
  end
end
