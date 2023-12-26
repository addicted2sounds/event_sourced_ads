class Events::AdCreated < Events::BaseEvent
  schema do
    Dry::Schema.Params do
      required(:title).filled(:string)
      required(:body).filled(:string)
    end
  end
end
