# frozen_string_literal: true

class ApplicationSerializer < ActiveModel::Serializer

  private

  def decorated_object
    @decorated_object ||= object.decorate
  end

  def serialize_objects_collection(array)
    return [] if array.blank?

    array.map { |hash| hash.as_json.symbolize_keys }
  end

  def serialize_record(record)
    record&.serialize_record || {}
  end
end
