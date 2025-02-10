# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_trial_parts
#
#  id              :bigint           not null, primary key
#  birth_date      :string
#  cnpj            :string
#  cpf             :string
#  gender          :string
#  kind            :string
#  name            :string
#  rg              :string
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  idwall_trial_id :bigint           not null
#
# Indexes
#
#  index_idwall_trial_parts_on_idwall_trial_id  (idwall_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_trial_id => idwall_trials.id)
#
FactoryBot.define do
  factory :idwall_trial_part, class: 'Idwall::TrialPart' do
    cnpj { nil }
    cpf { Faker::CPF.pretty }
    birth_date { Time.zone.today }
    name { Faker::Name.name }
    rg { Faker::IdNumber.brazilian_id }
    gender { nil }
    kind { nil }
    title { %w[REQTE REQDO].sample }

    idwall_trial factory: :idwall_trial
  end
end
