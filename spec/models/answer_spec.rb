# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id         :bigint           not null, primary key
#  complement :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  option_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_answers_on_option_id  (option_id)
#  index_answers_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (option_id => options.id)
#  fk_rails_...  (user_id => users.id)
#
require 'spec_helper'

RSpec.describe Answer, type: :model do
  describe 'factories' do
    subject { build :answer }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :option }
    it { is_expected.to belong_to :user }
  end
end
