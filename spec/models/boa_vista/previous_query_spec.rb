# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous_queries
#
#  id                            :bigint           not null, primary key
#  currency                      :string
#  date                          :string
#  informant                     :string
#  occurrence_type               :string
#  product                       :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_previous_queries_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::PreviousQuery, type: :model do
  describe 'factories' do
    subject { build :boa_vista_previous_query }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :boa_vista_acerta_essencial }
  end
end
