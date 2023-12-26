class Events::AdCreated < Events::BaseEvent
  schema do
    Dry::Schema.Params do
      required(:title).filled(:string)
      required(:description).filled(:string)
    end
  end
end
