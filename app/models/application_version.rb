# frozen_string_literal: true

require_relative 'application_record'

class ApplicationVersion < ApplicationRecord
  include PaperTrail::VersionConcern
  self.abstract_class = true
end
