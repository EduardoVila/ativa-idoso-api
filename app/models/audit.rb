# frozen_string_literal: true

class Audit < ApplicationVersion
  # using a custom table
  self.table_name = :audits
  self.sequence_name = :audits_id_seq

  # extra associations
  belongs_to :owner, polymorphic: true, optional: true

  delegate :name, to: :owner, prefix: true, allow_nil: true

  scope :with_owner, -> { where.not(owner_id: nil) }
end
