# frozen_string_literal: true

#
# Adds versioning behavior to records.
#
# Currently relying on PaperTrail gem.
#
# It should be included in ApplicationRecord and, in each auditable model,
# you must call
# ```
# class User < ApplicationRecord
#   auditable **options  # `has_paper_trail` options
# end
# ```
#
#
# You can find out auditable models with `Auditable.models` - an array of classes.
#

require 'paper_trail'

module Auditable
  extend ActiveSupport::Concern

  AUDIT_OPTIONS = {
    versions: { name: :audits, class_name: 'Audit' },
    on: %i[create update destroy],
    meta: { class_name: ->(record) { record.model_name.to_s } }
  }.freeze

  class_methods do
    def auditable(**options)
      Auditable.models << self unless Auditable.models.include?(self)

      has_paper_trail options.deep_merge(AUDIT_OPTIONS)
    end
  end

  def self.models_for_select
    models.map { |klass| [klass.model_name.human, klass.name] }.sort
  end

  def self.models
    @models ||= []
  end
end
