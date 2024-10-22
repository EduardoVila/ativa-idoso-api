# frozen_string_literal: true

class ApplicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  private

  def decorated_object
    @decorated_object ||= object.decorate
  end

  def serialize_objects_collection(array)
    return [] if array.blank?

    array.map { |hash| hash.as_json.symbolize_keys }
  end
end
