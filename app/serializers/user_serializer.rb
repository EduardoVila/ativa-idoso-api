# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  access_token :string
#  cpf          :string           not null
#  name         :string           not null
#  status       :integer          default("research_pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_cpf  (cpf) UNIQUE
#
require_relative 'application_serializer'

class UserSerializer < ApplicationSerializer
  attributes :id, :cpf, :name, :access_token, :status
end
