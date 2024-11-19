# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_processes
#
#  id                        :uuid             not null, primary key
#  lawsuits_total            :integer
#  defendant_lawsuits_total  :integer
#  plaintiff_lawsuits_total  :integer
#  provenir_big_data_corp_id :uuid             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
FactoryBot.define do
  factory :provenir_process, class: 'Provenir::Process' do
    lawsuits_total { 0 }
    big_data_corp factory: :provenir_big_data_corp
  end
end
