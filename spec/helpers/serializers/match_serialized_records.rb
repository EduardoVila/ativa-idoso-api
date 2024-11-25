# frozen_string_literal: true

require 'rspec/expectations'

#
#   Módulo de suporte para specs com ActiveModel::Serializers, fornecendo
# matchers.
#
module MatchSerializerRecordSupportMatcher
  extend RSpec::Matchers::DSL

  #
  # Matcher para facilitar testes em serializadores.
  #
  # Uso:
  #
  # let(:instance) { build :model }
  # let(:serializer_class) { ModelSerializer }
  # subject(:hash) { serializer.as_json }
  #
  # it { is_expected
  #  .to match_serialized_record instance, with: serializer_class }
  #
  #
  # expect(controller.app_data[:current_user]).to match_serialized_record user
  #
  matcher :match_serialized_record do |record, with: nil|
    match do |serialized_data|
      # comparing as json to avoid problems with Date, DateTime, ...
      json_serialized_data = if serialized_data.is_a?(String)
                               serialized_data
                             else
                               serialized_data.to_json
                             end

      serialized_record = record.serialize_record with: with
      expect(json_serialized_data).to eq serialized_record.to_json
    end
  end

  # it { is_expected.to match_serialized_records instance, another_instance,
  #   with: serializer_class }
  # expect(controller.app_data[:properties])
  #  .to match_serialized_records property, another_property
  matcher :match_serialized_records do |*records, with: nil|
    match do |serialized_data|
      # comparing as json to avoid problems with Date, DateTime, ...
      json_serialized_data = if serialized_data.is_a?(String)
                               serialized_data
                             else
                               serialized_data.map(&:to_json)
                             end

      # Aqui há uma "pegadinha" de argumentos arrays e blocos.
      #   Veja: https://makandracards.com/makandra/20641-careful-when-calling-a-ruby-block-with-an-array
      serialized_records = [records].flatten.map do |rec|
        rec.serialize_record with: with
      end
      expect(json_serialized_data)
        .to match_array serialized_records.map(&:to_json)
    end
  end
end

# RSpec.configure do |config|
#   # disponível para todos os tipos de testes (controller, model, ...)
#   config.include MatchSerializerRecordSupportMatcher
# end
