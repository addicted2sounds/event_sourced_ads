module Events
  class BaseEvent
    class InvalidAttributes < StandardError; end

    class MissingContract < StandardError; end

    class << self
      def schema(&block)
        inner_schema = block.call
        define_singleton_method(:params_schema) do
          Dry::Schema.Params do
            required(:data).hash(inner_schema)
          end
        end
      end

      def publish(**args)
        data_validation = params_schema.call(args)
        raise InvalidAttributes.new(data_validation.errors.to_h) if data_validation.errors.any?
        Event.create!(
          event_type: name, **args
        )
        ActiveSupport::Notifications.instrument(name, args)
      end

      def params_schema
        ->(_) { raise MissingContract, "Contract needs to be implemented" }
      end
    end
  end
end
