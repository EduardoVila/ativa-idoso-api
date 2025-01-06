# frozen_string_literal: true

# Invoker: API of the command pattern to execute different commands.
#
# The workflow of the alpop-analysis project is based on the command pattern.
#
# The Invoker class is responsible for executing various commands
# defined in the COMMANDS hash. It provides a unified interface to call
# different command classes with the given arguments.
#
# COMMANDS:
# - :analysis_report_runner_command -> Analysis::ReportRunnerCommand
# - :analysis_item_runner_command -> Analysis::ItemRunnerCommand
# - :api_webhook_trigger_command -> API::WebhookTriggerCommand
# - :boa_vista_cadastral_command -> BoaVista::CadastralCommand
# - :analysis_step_command -> Analysis::StepCommand
# - :analysis_report_sync_command -> Analysis::ReportSyncCommand
#
# Methods:
# - self.execute(*args): Class method to create a new instance and call the instance method execute.
# - execute(command, arg, klass_name = nil): Executes the specified command with the given argument.
#   - command: Symbol representing the command to be executed.
#   - object: Object to be passed to the command.
#   - klass_name: Optional class name to be used if the command is :a_step.
#
# Raises:
# - ArgumentError: If the command is not found in the COMMANDS hash and is not :a_step.
class Invoker
  COMMANDS = {
    analysis_report_runner_command: 'Analysis::ReportRunnerCommand',
    analysis_item_runner_command: 'Analysis::ItemRunnerCommand',
    api_webhook_trigger_command: 'API::WebhookTriggerCommand',
    boa_vista_cadastral_command: 'BoaVista::CadastralCommand',
    analysis_step_command: 'Analysis::StepCommand',
    analysis_report_sync_command: 'Analysis::ReportSyncCommand'
  }.freeze

  def self.execute(*)
    new.execute(*)
  end

  def execute(command, object, klass_name = nil)
    if COMMANDS.key?(command.to_sym)
      COMMANDS[command.to_sym].constantize.call(object)
    elsif command == :a_step
      klass_name.constantize.call(object)
    else
      raise ArgumentError, "Unknown command: #{command}"
    end
  end
end
