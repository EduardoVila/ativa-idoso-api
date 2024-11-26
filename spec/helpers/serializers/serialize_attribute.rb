# frozen_string_literal: true

require 'rspec/expectations'

module SerializeAttributeSupportMatcher
  extend RSpec::Matchers::DSL

  #
  # Matcher para facilitar testes em serializadores.
  #
  # Uso:
  #
  # let(:instance) { build :model }
  # let(:serializer) { ModelSerializer.new instance }
  # subject(:hash) { serializer.as_json }
  #
  # it { is_expected.to serialize_attribute(:name).from(instance) }
  # it { is_expected.to serialize_attribute(:price)
  #   .as(instance.price.round(2)) }
  # it { is_expected.to serialize_attribute(:price)
  #   .as custom_format(instance.price) }
  # it { is_expected.to serialize_attribute(:lat).as(instance.lat.to_f) }
  #
  matcher :serialize_attribute do |attribute|
    match do |serialized_data|
      @serialized_key = attribute

      @has_key = serialized_data.key?(@serialized_key)

      return false unless @has_key

      @serialized_value = serialized_data[@serialized_key]
      @target_value = if @has_custom_value
                        @custom_value
                      else
                        @record.public_send(attribute)
                      end

      @serialized_value == @target_value
    end

    chain :from do |record|
      @record = record
    end

    chain :as do |custom_value|
      @has_custom_value = true
      @custom_value = custom_value
    end

    failure_message do |serialized_data|
      if @has_key
        <<~LOG
          expected key '#{@serialized_key}' to
            be:  #{v_to_s(@target_value)}
            got: #{v_to_s(@serialized_value)}
        LOG
      else
        <<~LOG
          expected #{serialized_data} to include key #{@serialized_key}
            keys found: #{serialized_data.keys}
        LOG
      end
    end

    # "value to string"
    def v_to_s(value)
      case value
      when String
        "\"#{value}\""
      when nil
        'nil'
      else
        value.to_s
      end
    end
  end
end

# RSpec.configure do |config|
#   config.include SerializeAttributeSupportMatcher, type: :serializer
# end
