# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_addresses
#
#  id                :bigint           not null, primary key
#  main              :string
#  city              :string
#  state             :string
#  number            :string
#  zip_code          :string
#  street            :string
#  neighborhood      :string
#  people_at_address :string
#  kind              :string
#  idwall_report_id  :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
module Idwall
  class Address < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'
  end
end
