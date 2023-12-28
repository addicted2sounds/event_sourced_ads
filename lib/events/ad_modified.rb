class Events::AdModified < Events::BaseEvent
  schema do
    Dry::Schema.Params do
      required(:ad_id).filled(:string)
      optional(:title).filled(:string)
      optional(:body).filled(:string)
    end
  end
end
