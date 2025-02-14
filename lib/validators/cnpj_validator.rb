# frozen_string_literal: true

class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if CNPJ.valid?(value)

    record.errors.add(attribute, options[:message] || :invalid)
  end
end
