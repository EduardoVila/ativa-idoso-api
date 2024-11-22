# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_trial_parts
#
#  id              :bigint           not null, primary key
#  cnpj            :string
#  cpf             :string
#  birth_date      :string
#  name            :string
#  rg              :string
#  gender          :string
#  kind            :string
#  title           :string
#  idwall_trial_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
