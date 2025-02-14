# frozen_string_literal: true

RSpec.shared_examples 'password_complexity' do |klass|
  describe 'validations' do
    describe '#password_complexity' do
      context 'when password is valid' do
        let(:user) { build formatted_class(klass) }

        it 'creates the resource' do
          expect(user.save).to be_truthy
        end
      end

      context 'when password is not valid' do
        let(:user) { build formatted_class(klass), password: '12345678a' }
        let(:errors) { user.errors }

        it 'does not create the resource' do
          expect(user.save).to be_falsey
          expect(errors.count).to eq(1)
          expect(errors.first.type).to eq(:invalid)
        end
      end
    end
  end

  private

  def formatted_class(klass)
    klass.to_s.underscore.tr('/', '_').to_sym
  end
end
