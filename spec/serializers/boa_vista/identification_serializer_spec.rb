# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_identifications
#
#  id                            :bigint           not null, primary key
#  birth_city                    :string
#  birth_date                    :string
#  consulted_gender              :string
#  cpf_zone                      :string
#  death                         :string
#  dependent_number              :string
#  document                      :string
#  educational_level             :string
#  emitting_organ                :string
#  marital_status                :string
#  mother_name                   :string
#  name                          :string
#  register                      :string
#  register_size                 :string
#  revenue_situation             :string
#  rg_emitting_date              :string
#  rg_federative_unit            :string
#  rg_number                     :string
#  update_date                   :string
#  voter_title                   :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_identifications_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
