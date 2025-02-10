# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_score_rating_several_models
#
#  id                            :bigint           not null, primary key
#  alphabetic_classification     :string
#  code_kind_model               :string
#  kind_description              :string
#  message                       :string
#  numeric_classification        :string
#  plan_name                     :string
#  probability                   :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  score                         :string
#  score_model                   :string
#  score_name                    :string
#  score_type                    :string
#  text                          :string
#  text_2                        :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_score_rating_several_models_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
