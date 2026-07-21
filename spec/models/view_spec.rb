# frozen_string_literal: true

# == Schema Information
#
# Table name: views
#
#  id                 :bigint           not null, primary key
#  percentage_watched :integer          default(0)
#  watched_completely :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#  video_id           :bigint           not null
#
# Indexes
#
#  index_views_on_user_id   (user_id)
#  index_views_on_video_id  (video_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (video_id => videos.id)
#
require 'spec_helper'

RSpec.describe View, type: :model do
  describe 'factories' do
    subject { build :view }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :video }
  end

  describe 'validations' do
    describe 'percentage_watched' do
      it do
        expect(subject).to(
          validate_numericality_of(:percentage_watched)
            .is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100)
        )
      end
    end

    describe 'watched_completely' do
      it {
        expect(subject).to(
          validate_inclusion_of(:watched_completely)
            .in_array([true, false])
        )
      }
    end
  end
end
