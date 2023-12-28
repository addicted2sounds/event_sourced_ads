class Events::AdRemoved < Events::BaseEvent
  schema do
    Dry::Schema.Params do
      required(:ad_id).filled(:string)
      required(:reason).filled(:string)
    end
  end
end
