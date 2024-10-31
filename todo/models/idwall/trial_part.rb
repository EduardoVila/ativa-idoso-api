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
#  idwall_trial_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module Idwall
  class TrialPart < ApplicationRecord
    belongs_to :idwall_trial, class_name: 'Idwall::Trial', optional: true
  end
end
