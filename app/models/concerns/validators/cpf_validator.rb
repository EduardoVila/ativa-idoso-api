# frozen_string_literal: true

# based on: https://github.com/sobrinho/cpf_validator
class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if CPF.valid?(value)

    record.errors.add(attribute, options[:message] || :invalid)
  end
end
