# frozen_string_literal: true

RSpec.describe PublicKey, type: :model do
  describe 'factories' do
    subject { build :public_key }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:issuer) }
    it { is_expected.to validate_presence_of(:algorithm) }
    it { is_expected.to validate_presence_of(:valid_from) }
    it { is_expected.to validate_presence_of(:valid_to) }
  end
end
