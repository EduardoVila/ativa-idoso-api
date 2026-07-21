# frozen_string_literal: true

class ApplicationSerializer < ActiveModel::Serializer

  private

  def serialize_objects_collection(resources)
    return [] if resources.blank?

    resources.map(&:serialize_record)
  end

  def serialize_record(record)
    record&.serialize_record || {}
  end
end
