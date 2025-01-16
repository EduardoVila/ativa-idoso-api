# # frozen_string_literal: true

# require 'spec_helper'

# RSpec.describe PerformScoreStepService do
#   subject { described_class.call(score, score_step) }

#   describe '#call' do
#     context 'when it performs correctly' do
#       let(:score) { create :score }
#       let(:score_step) { create :score_step }

#       before do
#         allow(Object.const_get(score_step.command_class)).to receive(:call)
#       end

#       it 'calls score step command' do
#         expect(Object.const_get(score_step.command_class)).to receive(:call)
#           .once.with(score)

#         subject
#       end

#       it 'changes status of score to wip and after to done' do
#         expect(score).to receive(:update).once.with(status: :wip)
#         expect(score).to receive(:update).once.with(status: :done)

#         expect { subject }.to change { score.steps.count }.by(1)
#       end
#     end

#     context 'when score has already score step runned' do
#       let(:score) { create :score }
#       let(:score_step) { create :score_step }

#       before do
#         score.steps << score_step
#       end

#       it 'does nothing' do
#         expect(Object.const_get(score_step.command_class)).not_to receive(:call)
#         expect(score).not_to receive(:update)

#         subject
#       end
#     end

#     context 'when missing score' do
#       let(:score_step) { create :score_step }
#       let(:score) { nil }

#       it 'does nothing' do
#         expect(Object.const_get(score_step.command_class)).not_to receive(:call)
#         expect(score).not_to receive(:update)

#         subject
#       end
#     end

#     context 'when missing score step' do
#       let(:score) { create :score }
#       let(:score_step) { nil }

#       it 'does nothing' do
#         expect(score).not_to receive(:update)

#         subject
#       end
#     end
#   end
# end
