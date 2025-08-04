# frozen_string_literal: true

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

  object_instance.destroy if blank_and_childless?(object_instance)
end

def filter_collection(object, association)
  alias_name = association.name
  collection = object.send(alias_name)

  return if collection.nil?

  collection.each do |item|
    # Recursively process each item in the collection
    traverse_and_filter(item)

    item.destroy if blank_and_childless?(item)
  end
end

def blank_and_childless?(object)
  relevant_attributes = filter_relevant_attributes(object.attributes)
  relevant_attributes.values.all?(&:blank?) && !object.children_present?
end

def filter_relevant_attributes(attributes)
  attributes.reject do |key, _|
    key.match?(/_id$/) || %w[id created_at updated_at].include?(key)
  end
end

namespace :destroy_blank_childless_objects do
  desc 'destroy blank childless objects from a root model.' \
       'e.g.: `ROOT_MODEL=BlogPost rake destroy_blank_childless_objects:run`'
  task run: :environment do
    # Recursively traverse the object's associations and remove blank objects.

    model = ENV['ROOT_MODEL'].constantize if ENV['ROOT_MODEL'].present?

    abort('ROOT_MODEL env is required. e.g.: ROOT_MODEL=BlogPost') if model.nil?

    model.find_in_batches do |objects|
      objects.each { |object| traverse_and_filter(object) }
    end
  end
end
