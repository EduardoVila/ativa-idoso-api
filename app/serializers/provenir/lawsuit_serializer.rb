# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class LawsuitSerializer < ApplicationSerializer
    attributes :id, :trial_number, :uf, :court, :delivery_date,
               :area, :trial_class_name, :defendant, :disapproved

    def defendant
      object.defendant?
    end

    def disapproved
      object.disapproved?
    end

    def uf
      object.state
    end

    def trial_number
      object.lawsuit_number
    end

    def delivery_date
      object.notice_date
    end

    def area
      object.main_subject
    end

    def trial_class_name
      object.lawsuit_type
    end

    def court
      object.court_name
    end
  end
end
