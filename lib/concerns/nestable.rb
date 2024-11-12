# frozen_string_literal: true

module Nestable
  extend ActiveSupport::Concern

  private

  def initialize_object_with_nested_attributes(parsed_response_body)
    klass_model.new(
      initialize_nested_attributes(parsed_response_body, klass_model.new)
    )
  end

  def klass_model
    Object.const_get(klass_name)
  end

  def klass_name
    self.class.name.gsub('Integrators', '')
  end

  def enable_nested_relations
    false
  end

  def initialize_nested_attributes(item, object) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    item.deep_transform_keys!(&:underscore)
    item.map do |key, value| # rubocop:disable  Performance/MapCompact
      next unless key != 'id' && object.respond_to?(key.to_s)

      key_class_name = object.public_send(key)&.name

      if value.is_a?(Array) && key_class_name # formatting has_many relations (E.g. bills has many receivements)
        value.map! do |item|
          class_name = object.public_send(key)&.name

          next if class_name.blank?

          key_class =  Object.const_get(class_name)
          key_object = key_class.new(
            initialize_nested_attributes(item, key_class.new)
          )

          key_object.raw_data = item if key_object.respond_to? :raw_data

          key_object
        end
      end

      if enable_nested_relations && value.is_a?(Hash) # formatting has_one relations using nested attributes
        attribute_key = object.class.attribute_alias(key) || key
        nested_reflection = object.class.reflect_on_association(attribute_key)
        nested_object = nested_reflection&.klass

        next unless nested_object.present?

        key = "#{key}_attributes"

        value = initialize_nested_attributes(value, nested_object.new)

        next if value.nil?
      end

      if key.include?('dt') && value.present? # putting dates in the correct format
        value = Date.strptime(value, '%m/%d/%Y')
      end

      { key => value }
    end.compact.reduce(:update)
  end
end
