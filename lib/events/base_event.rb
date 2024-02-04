module Events
  class BaseEvent
    class InvalidAttributes < StandardError; end

    class MissingContract < StandardError; end

    attr_reader :data

    def self.schema(&block)
      inner_schema = block.call
      define_method(:params_schema) do
        Dry::Schema.Params do
          required(:data).hash(inner_schema)
        end
      end
    end

    def self.publish(**args)
      new(**args.slice(:data)).publish(stream_name: args[:stream_name])
    end


    def initialize(**args)
      validate_input(args)
      @data = args[:data]
    end

    def publish(stream_name: nil)
      Event.create!(
        event_type: self.class.name, data:, stream_name:
      )
      ActiveSupport::Notifications.instrument(self.class.name, data:, stream_name:)
      self
    end

    def params_schema
      ->(_) { raise MissingContract, "Contract needs to be implemented" }
    end

    def validate_input(args)
      data_validation = params_schema.call(args)
      raise InvalidAttributes.new(data_validation.errors.to_h) if data_validation.errors.any?
    end
  end
end
