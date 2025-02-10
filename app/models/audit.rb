# frozen_string_literal: true

# == Schema Information
#
# Table name: audits
#
#  id         :bigint           not null, primary key
#  class_name :string           not null
#  event      :string           not null
#  ip         :string
#  item_type  :string           not null
#  object     :text
#  owner_type :string
#  user_agent :string
#  whodunnit  :string
#  created_at :datetime
#  item_id    :integer          not null
#  owner_id   :bigint
#
# Indexes
#
#  index_audits_on_class_name             (class_name)
#  index_audits_on_item_type_and_item_id  (item_type,item_id)
#  index_audits_on_owner                  (owner_type,owner_id)
#
require_relative 'application_version'

class Audit < ApplicationVersion
  # using a custom table
  self.table_name = :audits
  self.sequence_name = :audits_id_seq

  # extra associations
  belongs_to :owner, polymorphic: true, optional: true

  delegate :name, to: :owner, prefix: true, allow_nil: true

  scope :with_owner, -> { where.not(owner_id: nil) }
end
