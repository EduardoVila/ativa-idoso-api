# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

ApplicationLoader.load_gems
ApplicationLoader.load_app

# analysis_steps is an array of hashes where each hash represents a step in the analyis process.
# Each step contains the following keys:
# - :name: A symbol representing the name of the analyis step.
# - :command_class: A string representing the class name of the command to be executed for this step.
# - :index_order: An integer representing the order in which the step should be executed.
analysis_steps = [
  {
    name: :pro_score_bounced_checks,
    command_class: 'ProScore::BouncedCheckCommand',
    index_order: 1
  },
  {
    name: :provenir_big_data_corp,
    command_class: 'Provenir::BigDataCorpCommand',
    index_order: 2
  },
  {
    name: :boa_vista_acerta_essencial,
    command_class: 'BoaVista::AcertaEssencialCommand',
    index_order: 3
  },
  {
    name: :pre_predictions,
    command_class: 'PrePredictionCommand',
    index_order: 4
  },
  {
    name: :predictions,
    command_class: 'Analysis::PredictionCommand',
    index_order: 5
  }
]

analysis_steps.each do |analysis_step|
  Analysis::Step.find_or_create_by(analysis_step)
end
