# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_monthly_benefits
#
#  id                                :bigint           not null, primary key
#  beneficio_concedido_judicialmente :string
#  mes_competencia                   :string
#  mes_referencia                    :string
#  nis_beneficiario                  :string
#  nome_municipio                    :string
#  numero_beneficio                  :string
#  numero_plugin                     :string
#  uf                                :string
#  valor_parcela                     :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  pro_score_report_id               :bigint           not null
#
# Indexes
#
#  index_pro_score_monthly_benefits_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
require 'spec_helper'

RSpec.describe ProScore::MonthlyBenefit, type: :model do
  describe 'factories' do
    subject { build :pro_score_monthly_benefit }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:monthly_benefits)
    }
  end
end
