# frozen_string_literal: true

# Removes blank objects from the object's associations before saving it.
module BlankObjectFilterable
  extend ActiveSupport::Concern

  private

  included do
    before_create :remove_blank_objects
  end

  def remove_blank_objects
    traverse_and_filter(self)
  end

  # Recursively traverse the object's associations and remove blank objects.
  def traverse_and_filter(object)
    object.class.reflect_on_all_associations.each do |association|
      case association.macro
      when :has_one
        filter_association(object, association)
      when :has_many
        filter_collection(object, association)
      end
    end
  end

  def filter_association(object, association)
    alias_name = association.name
    object_instance = object.send(alias_name)

    return if object_instance.nil?

    # Recursively process child associations
    traverse_and_filter(object_instance)

    object_instance.mark_for_destruction if blank_object?(object_instance)
  end

  def filter_collection(object, association)
    alias_name = association.name
    collection = object.send(alias_name)

    return if collection.nil?

    collection.each do |item|
      # Recursively process each item in the collection
      traverse_and_filter(item)

      item.mark_for_destruction if blank_object?(item)
    end
  end

  def blank_object?(object)
    relevant_attributes = filter_relevant_attributes(object.attributes)
    relevant_attributes.values.all?(&:blank?) && !object.children_present?
  end

  def filter_relevant_attributes(attributes)
    attributes.reject do |key, _|
      key.match?(/_id$/) || %w[id created_at updated_at].include?(key) # rubocop:disable Performance/CollectionLiteralInLoop
    end
  end
end
