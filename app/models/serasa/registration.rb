# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_registrations
#
#  id                       :bigint           not null, primary key
#  birth_date               :string
#  consumer_name            :string
#  document_number          :string
#  mother_name              :string
#  status_date              :date
#  status_registration      :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_registrations_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
#
module Serasa
  class Registration < ApplicationRecord
    belongs_to :fintech_report,
               class_name: 'Serasa::FintechReport',
               foreign_key: 'serasa_fintech_report_id',
               inverse_of: :registration

    has_one :address,
            class_name: 'Serasa::Address',
            dependent: :destroy,
            foreign_key: 'serasa_registration_id',
            inverse_of: :registration

    has_one :phone, class_name: 'Serasa::Phone',
                    as: :owner,
                    dependent: :destroy,
                    inverse_of: :owner

    validates :serasa_fintech_report_id, uniqueness: true

    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :phone
  end
end
