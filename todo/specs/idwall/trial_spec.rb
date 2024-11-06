# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Idwall::Trial, type: :model do
  describe 'factories' do
    subject { build :idwall_trial }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:idwall_report) }
    it { is_expected.to have_many(:trial_parts) }
  end

  describe '#own_part_required?' do
    context 'when is required' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQTE',
          name: 'JOAO DA SILVA SANTOS'
        )
      end

      it 'returns true' do
        expect(subject).to be_own_part_required
      end
    end

    context 'when is suitor' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQTE',
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'JOAO DA SILVA SANTOS'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_own_part_required
      end
    end

    context 'when there are missing data' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQTE',
          name: 'JONAS SANTOS'
        )
      end

      it 'returns true' do
        expect(subject).to be_own_part_required
      end
    end

    context 'when the trial name is different of the cpf name' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQTE',
          name: 'EDUARDO DE VILLA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'JOAO MANOEL'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_own_part_required
      end
    end

    context 'when the name of the required is nearest than the suitor' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'EDUARDO DE VILLA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERENTE',
          name: 'EDUARDO MANOEL DE VILA'
        )
      end

      it 'returns true' do
        expect(subject).to be_own_part_required
      end
    end

    context 'when the name of the suitor is nearest than the required' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'EDUARDO MANOEL DE VILA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERENTE',
          name: 'EDUARDO DE VILLA'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_own_part_required
      end
    end

    context 'when is suitor and have more than one suitor in the trial' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'JONAS DOS SANTOS PEREIRA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'IMPETRANTE',
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part2) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'IMPETRANTE',
          name: 'EDIMUNDO SANTOS'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_own_part_required
      end
    end

    context 'when is required and have more than one required in the trial' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'JONAS DOS SANTOS PEREIRA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part2) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'IMPETRANTE',
          name: 'EDIMUNDO SANTOS'
        )
      end

      it 'returns true' do
        expect(subject).to be_own_part_required
      end
    end

    context 'when is required and have more than one suitor in the trial' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'IMPETRANTE',
          name: 'THAIS PEREIRA'
        )
      end
      let!(:trial_part2) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'IMPETRANTE',
          name: 'EDIMUNDO SANTOS'
        )
      end

      it 'returns true' do
        expect(subject).to be_own_part_required
      end
    end

    context 'when is suitor and have more than one required in the trial' do
      subject { create :idwall_trial }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'JONAS DOS SANTOS PEREIRA'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'IMPETRANTE',
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part2) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQUERIDO',
          name: 'EDIMUNDO SANTOS'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_own_part_required
      end
    end
  end

  describe '#defendant_and_disapproved?' do
    context 'when is required and disapproved' do
      subject { create :idwall_trial, subject: 'Despejo' }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end

      it 'returns true' do
        expect(subject).to be_defendant_and_disapproved
      end
    end

    context 'when is required but approved' do
      subject { create :idwall_trial, subject: 'Bla bla', kind: 'Bla bla' }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end

      it 'returns false' do
        expect(subject).to be_defendant_and_disapproved
      end
    end

    context 'when is suitor but disapproved' do
      subject { create :idwall_trial, subject: 'Despejo' }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQTE',
          name: 'eduardo de vila'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'jonas santos'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_defendant_and_disapproved
      end
    end

    context 'when is suitor, and approved' do
      subject { create :idwall_trial, subject: 'Bla bla', kind: 'Bla bla' }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQTE',
          name: 'eduardo de vila'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo da vila'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_defendant_and_disapproved
      end
    end

    context 'when the subject is empty and the kind is disapproved' do
      subject { create :idwall_trial, subject: nil }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end

      it 'returns true' do
        expect(subject).to be_defendant_and_disapproved
      end
    end

    context 'when the subject is empty and the kind is approved' do
      subject { create :idwall_trial, subject: nil, kind: 'Bla bla bla' }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end

      it 'returns false' do
        expect(subject).to be_defendant_and_disapproved
      end
    end

    context 'when the kind is empty and the subject is disapproved' do
      subject { create :idwall_trial, kind: nil, subject: 'Dano material' }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end

      it 'returns true' do
        expect(subject).to be_defendant_and_disapproved
      end
    end

    context 'when the kind is empty and the subject is approved' do
      subject { create :idwall_trial, kind: nil, subject: 'Bla bla bla' }

      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject.idwall_report,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: subject,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end

      it 'returns false' do
        expect(subject).to be_defendant_and_disapproved
      end
    end
  end
end
