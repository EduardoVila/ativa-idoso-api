# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_basic_registrations
#
#  id                     :bigint           not null, primary key
#  birth_date             :string
#  cpf                    :string
#  cpf_situation          :string
#  exposed_person         :string
#  mother_name            :string
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  boa_vista_cadastral_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_basic_registrations_on_boa_vista_cadastral_id  (boa_vista_cadastral_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_id => boa_vista_cadastrals.id)
#
module BoaVista
  class BasicRegistration < ApplicationRecord
    belongs_to :boa_vista_cadastral,
               class_name: 'BoaVista::Cadastral',
               inverse_of: :basic_registration

    validates :boa_vista_cadastral_id, uniqueness: true

    alias_attribute :nome, :name
    alias_attribute :nome_mae, :mother_name
    alias_attribute :data_nascimento, :birth_date
    alias_attribute :pessoa_politicamente_exposta, :exposed_person
    alias_attribute :situacao_cpf, :cpf_situation

    def age
      birth_date = self.birth_date

      return unless birth_date.present? && valid_datetime?(birth_date)

      birth_date_datetime = birth_date.to_datetime

      today = Time.zone.today
      age = today.year - birth_date_datetime.year
      age -= 1 if today < birth_date_datetime + age.years

      age
    end

    private

    def valid_datetime?(value)
      value.to_datetime

      true
    rescue ArgumentError
      false
    end
  end
end
