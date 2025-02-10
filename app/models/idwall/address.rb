# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_addresses
#
#  id                :bigint           not null, primary key
#  city              :string
#  kind              :string
#  main              :string
#  neighborhood      :string
#  number            :string
#  people_at_address :string
#  state             :string
#  street            :string
#  zip_code          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  idwall_report_id  :bigint           not null
#
# Indexes
#
#  index_idwall_addresses_on_idwall_report_id  (idwall_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
#
module Idwall
  class Address < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'
  end
end
