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

require_relative 'application_record'

class Answer < ApplicationRecord
  belongs_to :option
  belongs_to :user
end
