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
class User < ApplicationRecord
  before_validation :cpf_normalizer
  before_create :generate_access_token

  enum :status, { research_pending: 0, active: 1 }

  with_options presence: true do
    validates :cpf, presence: true, unless: :anonymous?
    validates :name
  end

  validates :cpf, cpf: true, if: -> { cpf.present? }
  validates :device_id, presence: true, uniqueness: true, if: :anonymous?

  has_many :answers, dependent: :destroy
  has_many :views, dependent: :destroy
  has_one :satisfaction_survey_response, dependent: :destroy

  private

  def generate_access_token
    self.access_token = SecureRandom.hex(16)
  end

  def cpf_normalizer
    self.cpf = CPF::Formatter.format cpf if cpf.present?
  end
end
