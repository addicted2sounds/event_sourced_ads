class Events::AdCreated < Events::BaseEvent
  schema do
    Dry::Schema.Params do
      required(:ad_id).filled(:string)
      required(:title).filled(:string)
      required(:body).filled(:string)
    end
  end
end
