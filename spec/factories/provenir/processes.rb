# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_processes
#
#  id                        :bigint           not null, primary key
#  defendant_lawsuits_total  :integer
#  lawsuits_total            :integer
#  plaintiff_lawsuits_total  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_process_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
FactoryBot.define do
  factory :provenir_process, class: 'Provenir::Process' do
    lawsuits_total { 0 }
    big_data_corp factory: :provenir_big_data_corp
  end
end
