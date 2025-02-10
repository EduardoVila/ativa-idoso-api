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
module Idwall
  class TrialPart < ApplicationRecord
    belongs_to :idwall_trial, class_name: 'Idwall::Trial', optional: true
  end
end
