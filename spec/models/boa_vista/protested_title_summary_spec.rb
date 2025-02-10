# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_title_summaries
#
#  id                            :bigint           not null, primary key
#  accumulated_value             :string
#  currency                      :string
#  federative_unit               :string
#  final_period                  :string
#  initial_period                :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  idx_on_boa_vista_acerta_essencial_id_f338e63983  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::ProtestedTitleSummary, type: :model do
  describe 'factories' do
    subject { build :boa_vista_protested_title_summary }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
