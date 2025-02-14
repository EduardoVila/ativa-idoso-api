# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    return if value&.match?(valid_email_regex)

    record.errors.add(attribute, options[:message] || :invalid)
  end
end
