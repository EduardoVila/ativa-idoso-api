# frozen_string_literal: true

module Formattable
  extend ActiveSupport::Concern

  def get_object # rubocop:disable Naming/AccessorMethodName
    Object.const_get(model_name)
  end

  def model_name
    self.class.name.gsub('Integrators', '')
  end

  def formatter(item, class_name) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    object = Object.const_get(class_name).new

    item.deep_transform_keys!(&:underscore)
    item.map do |key, value| # rubocop:disable Performance/MapCompact
      next unless key != 'id' && object.respond_to?(key.to_s)

      object_key = object.public_send(key)
      class_name = object_key &&
                   object_key.class.to_s.include?(
                     'ActiveRecord_Associations_CollectionProxy'
                   ) &&
                   object.public_send(key).name

      if value.is_a?(Array) && class_name # formatting has_many relations (E.g. bills has many receivements)
        value.map! do |item|
          key_class =  Object.const_get(class_name)
          key_object = key_class.new(
            formatted_item(item, key_class.new)
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

        value = formatted_item(value, nested_object.new)

        next if value.nil?
      end

      { key => value }
    end.compact.reduce(:update)
  end

  def enable_nested_relations
    false
  end
end
