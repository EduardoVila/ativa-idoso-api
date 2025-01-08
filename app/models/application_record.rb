# frozen_string_literal: true

require 'active_record'
require_relative 'concerns/auditable'

class ApplicationRecord < ActiveRecord::Base
  include ::Auditable

  self.abstract_class = true

  def self.human_enum_name(name, value)
    I18n.t("activerecord.enums.#{model_name.singular}.#{name}.#{value}")
  end

  singleton_class.send :alias_method, :enum_t, :human_enum_name
  singleton_class.send :alias_method, :attr_t, :human_attribute_name

  def human_enum_name(name)
    value = send(name)
    self.class.human_enum_name(name, value) if value.present?
  end

  alias enum_t human_enum_name

  def enum?(attr)
    type_for_attribute(attr).class.ancestors
      .include? ActiveRecord::Enum::EnumType
  end

  def translate_enum(attr)
    human_enum_name(attr) if enum? attr
  end

  def list_enums
    attributes.select { |k| enum? k }.keys
  end

  def formatted_string(value = '')
    value.downcase.unaccent
  end

  def children_present?
    self.class.reflect_on_all_associations.any? do |association|
      case association.macro
      when :has_one
        send(association.name).present?
      when :has_many
        send(association.name).any?
      end
    end
  end

  def serialize_record(with: nil)
    serializer_class = with || "#{self.class.name}Serializer".constantize

    record_serializer = serializer_class.new(self)

    record_serializer.serializable_hash
  end

  def self.deserialize_record(serialized_data)
    find(serialized_data[:id])
  end
end
