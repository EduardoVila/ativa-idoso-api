# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_score_rating_several_models
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  score_type                    :string
#  score                         :string
#  plan_name                     :string
#  score_model                   :string
#  score_name                    :string
#  numeric_classification        :string
#  alphabetic_classification     :string
#  probability                   :string
#  text                          :string
#  code_kind_model               :string
#  kind_description              :string
#  text_2                        :string
#  value                         :string
#  message                       :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::ScoreRatingSeveralModel, type: :model do
  describe 'factories' do
    subject { build :boa_vista_score_rating_several_model }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
