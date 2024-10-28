# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_steps
#
#  id            :uuid             not null, primary key
#  name          :string
#  command_class :integer
#  index_order   :integer
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
