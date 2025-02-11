# frozen_string_literal: true

module CommandResultsHash
  extend ActiveSupport::Concern

  def success_hash
    { status: 'success', approved: true, disapproval_situation: nil }
  end

  def reproved_hash(disapproval_situation)
    { status: 'success', approved: false, disapproval_situation: }
  end

  def failure_hash
    { status: 'failure', approved: false, disapproval_situation: nil }
  end

  def not_found_hash
    { status: 'not_found', approved: false, disapproval_situation: nil }
  end
end
