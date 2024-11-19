# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_basic_registrations
#
#  id                     :uuid             not null, primary key
#  cpf                    :string
#  name                   :string
#  mother_name            :string
#  birth_date             :string
#  exposed_person         :string
#  cpf_situation          :string
#  boa_vista_cadastral_id :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
module BoaVista
  class BasicRegistration < ApplicationRecord
    belongs_to :boa_vista_cadastral,
               class_name: 'BoaVista::Cadastral',
               inverse_of: :basic_registration

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
