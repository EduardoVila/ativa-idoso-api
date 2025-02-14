# frozen_string_literal: true

class CpfCnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if CPF.valid?(value) || CNPJ.valid?(value)

    record.errors.add(attribute, options[:message] || :invalid)
  end
end
