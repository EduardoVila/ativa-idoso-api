# frozen_string_literal: true

module Nestable
  extend ActiveSupport::Concern

  def initialize_object_with_nested_attributes(parsed_response_body)
    klass_model.new(
      initialize_nested_attributes(parsed_response_body, klass_model.new)
    )
  end

  def klass_model
    Object.const_get(klass_name)
  end

  def klass_name
    self.class.name.gsub('Integrator', '')
  end

  def initialize_nested_attributes(item, object) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    item.deep_transform_keys!(&:underscore)

    item.filter_map do |key, value|
      next unless key != 'id' && object.respond_to?(key.to_s) # skip id attribute

      if key.include?('dt') && value.present? # date format conversion
        value = Date.strptime(value, '%m/%d/%Y')
      end

      key = klass_alias(key, object) || key # alias key if present

      nested_klass = nested_klass(key, object) # get nested klass if present
      association_collection = association_collection?(key, object) # check if association is a collection

      # has_many association attributes initialization
      if value.is_a?(Array) && association_collection
        next if nested_klass.blank?

        # `value` will be overwrite by the initialized objects (note the `!`)
        value.map! do |attr_hash| # initialize object within collection
          init_object_within_collection(nested_klass.new, attr_hash)
        end
      end

      # has_one association attributes initialization
      if value.is_a?(Hash) && !association_collection
        next if nested_klass.blank?

        # pattern matching to overwrite `key` and `value`
        key, value = prepare_nested_attributes(nested_klass.new, key, value)

        next if value.nil?
      end

      # assign values to object attributes
      { key => value }
    end.reduce(:update) # merge all hashes into one hash
  end

  private

  def klass_alias(key, object)
    return unless object.class.respond_to?(:association_alias)

    object.class.association_alias(key)
  end

  def association_collection?(key, object)
    association_reflection = object.class.reflect_on_association(key)
    association_reflection&.collection?
  end

  def nested_klass(key, object)
    association_reflection = object.class.reflect_on_association(key)
    association_reflection&.klass
  end

  def init_object_within_collection(object, item)
    attr_hash = initialize_nested_attributes(item, object)

    object.attributes = attr_hash if attr_hash.present?
    object.raw_data = item if object.respond_to?(:raw_data)

    object
  end

  def prepare_nested_attributes(object, key, value)
    ["#{key}_attributes", initialize_nested_attributes(value, object)]
  end
end
