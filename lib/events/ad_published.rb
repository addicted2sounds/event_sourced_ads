class Events::AdPublished < Events::BaseEvent
  schema do
    Dry::Schema.Params do
      required(:ad_id).filled(:string)
      optional(:remote_id).value(:string)
    end
  end
end
