# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_registrations
#
#  id                       :uuid             not null, primary key
#  document_number          :string
#  consumer_name            :string
#  mother_name              :string
#  birth_date               :string
#  status_registration      :string
#  status_date              :date
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
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

    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :phone
  end
end
