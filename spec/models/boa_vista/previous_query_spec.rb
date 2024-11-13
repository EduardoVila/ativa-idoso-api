# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous_queries
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  date                          :string
#  currency                      :string
#  value                         :string
#  informant                     :string
#  product                       :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
