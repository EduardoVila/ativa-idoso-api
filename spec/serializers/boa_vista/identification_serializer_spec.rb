# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_identifications
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register                      :string
#  document                      :string
#  name                          :string
#  mother_name                   :string
#  birth_date                    :string
#  rg_number                     :string
#  emitting_organ                :string
#  rg_federative_unit            :string
#  rg_emitting_date              :string
#  consulted_gender              :string
#  birth_city                    :string
#  marital_status                :string
#  dependent_number              :string
#  educational_level             :string
#  revenue_situation             :string
#  update_date                   :string
#  cpf_zone                      :string
#  voter_title                   :string
#  death                         :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::IdentificationSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:identification) { build :boa_vista_identification }
  let(:serializer) { described_class.new identification }

  it { is_expected.to serialize_attribute(:id).from(identification) }
  it { is_expected.to serialize_attribute(:name).from(identification) }
  it { is_expected.to serialize_attribute(:birth_date).from(identification) }
end
