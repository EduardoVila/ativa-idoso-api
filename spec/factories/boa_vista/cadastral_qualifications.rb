# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_qualifications
#
#  id                     :bigint           not null, primary key
#  cpf                    :string           not null
#  death                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  boa_vista_cadastral_id :bigint           not null
#
# Indexes
#
#  idx_on_boa_vista_cadastral_id_353e336e1f  (boa_vista_cadastral_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_id => boa_vista_cadastrals.id)
#
FactoryBot.define do
  factory :boa_vista_cadastral_qualification,
          class: 'BoaVista::CadastralQualification' do
    cpf { Faker::CPF.pretty }
    death { 'false' }

    boa_vista_cadastral
  end
end
