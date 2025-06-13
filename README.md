# README #

## Alpop Analysis Setup Guide ##

### What is this repository for? ###

* Alpop Analysis API microservice
* Version 1.0

### Installation of Alpop Analysis ###

* Clone the repository:

```sh
git clone git@bitbucket.org:alpop-dev/alpop-analysis.git
cd <path/to>/alpop-analysis
```

* Install dependencies:

```sh
bundle install
```

* Configuration:

  * Ensure you have Ruby installed (version 3.4.2).
  * Create a `.env` file for environment variables.
  * Database configuration:
    * Set up your database (PostgreSQL).
    * Run migrations:

```sh
bundle exec rake db:migrate
```

* How to run tests:

```sh
bundle exec rspec
```

* To run local server in `localhost:3000`

```sh
bundle exec puma
```

* To start server and sidekiq/redis (needed to test jobs) in `localhost:5000`:

```sh
bundle exec foreman start
```

* To stop redis server in case of error when uploading server/sidekiq:

```sh
sudo service redis-server stop
```

---
---

## Architecture Overview and Main Flows ##

The alpop-analysis project follows a command pattern architecture using Sinatra as the web framework.

Sinatra is a lightweight, flexible, and powerful Ruby DSL (Domain-Specific Language) for building web applications. It's designed for simplicity and ease of use, allowing developers to quickly create dynamic web pages, APIs, and more with minimal setup and effort.

It builds upon the **Rack webserver** interface, which allows Ruby frameworks to interact with HTTP communications.

The API endpoints are organized in handlers within the handlers directory, with V1 namespace containing the main API logic. Every flow of the application starts at each endpoint.

---

### Creation of Analysis Report ###

**Handler**: `V1::CreateAnalysisReport`

**Endpoint**: Creates a new analysis report and initiates the analysis process.

#### Main components - CreateAnalysisReport ####

**Job**: `AnalysisReportJob` - Main job that orchestrates the entire analysis process

**Commands Used**:

* `Analysis::ReportRunnerCommand` - Runs the analysis report
* `Analysis::ItemRunnerCommand` - Processes individual - analysis items
* `Api::WebhookTriggerCommand` - Triggers webhook notifications

**Services**: Various analysis services for data processing and report generation

#### Flow - CreateAnalysisReport ####

1. Creates analysis report record
2. Enqueues AnalysisReportJob for background processing
3. Updates webhook event status to processing
4. Executes analysis steps sequentially
5. Triggers webhook upon completion

---

### Running Next Step of an Analysis ###

**Handler**: `V1::NextAnalysisStep`

**Endpoint**: Processes the next step in an analysis workflow.

#### Components - NextAnalysisStep ####

**Job**: NextAnalysisStepJob - Manages individual analysis step execution

**Commands Used**:

* `Analysis::NextStepCommand` - Executes the next analysis step
* Dynamic step commands (e.g., `PrePredictionCommand`, `Analysis::PredictionCommand`)
* Invoker Pattern: Uses Invoker with `:a_step` command to execute specific step classes, according to `index_order` of each step object previously created in database as a lookup table.

#### Flow - NextAnalysisStep ####

1. Validates analysis item and command class
2. Finds the enabled analysis step
3. Updates analysis item status to WIP
4. Executes the step command through Invoker
5. Handles approved/disapproved results
6. Creates analysis predictions when needed

---

### Retrying Analysis Report with error status ###

**Handler**: `V1::RetryAnalysisReport`

**Endpoint**: Retries a failed analysis report.

#### Components - RetryAnalysisReport ####

**Job**: AnalysisReportJob - Re-enqueued for retry processing

**Commands Used**: Same as CreateAnalysisReport flow

**Services**: Error handling and retry logic services

#### Flow - RetryAnalysisReport ####

1. Resets analysis report status
2. Re-enqueues AnalysisReportJob
3. Follows same flow as initial report creation. It will not run steps that were correctly made. The method `StepByStepCommand#should_be_skipped?` is responsible to verify if the junction object `item_step` has status `failed` or `completed`, thus is responsible to decide if the step will run again for the analysis item.

---

### Rerunning from start a Cloned Analysis Item ###

**Handler**: `V1::RerunCloneAnalysisItem`

**Endpoint**: Reruns analysis for a cloned analysis item.

#### Components - RerunCloneAnalysisItem ####

**Job**: RerunCloneAnalysisItemJob

**Commands Used**:

* `Analysis::ItemRunnerCommand` - Runs the analysis item, setting up its status and then calling.
* `StepByStepCommand`.
* `Analysis::StepByStepCommand` - Processes analysis steps sequentially

**Services**: Cloning and step processing services

#### Flow - RerunCloneAnalysisItem ####

1. Creates clone of original analysis item
2. Resets step execution status
3. Processes steps sequentially using StepByStepCommand
4. Updates model features and steps data

---

### API Authentication via credentials and Json Web Token - JWT ###

**Handler**: V1::Authenticate

**Endpoint**: Handles API authentication.

#### Components - Authentication ####

**Jobs**: None - synchronous authentication

**Commands**: Authentication-related commands

**Services**: JWT token validation and API client verification services

#### Flow - Authentication ####

1. Validates API credentials
2. Generates or validates authentication tokens
3. Returns authentication status

---

### Core Command Pattern Implementation ###

The application uses the `Invoker` class as the central command dispatcher, following a pattern known as [command pattern](https://en.wikipedia.org/wiki/Command_pattern):

Available Commands:

```ruby
# app/commands/invoker.rb

COMMANDS = {
    analysis_report_runner_command: 'Analysis::ReportRunnerCommand',
    analysis_item_runner_command: 'Analysis::ItemRunnerCommand',
    api_webhook_trigger_command: 'Api::WebhookTriggerCommand',
    boa_vista_cadastral_command: 'BoaVista::CadastralCommand',
    analysis_step_by_step_command: 'Analysis::StepByStepCommand',
    analysis_report_sync_command: 'Analysis::ReportSyncCommand',
    analysis_next_step_command: 'Analysis::NextStepCommand'
  }
```

#### Dynamic Step Execution ####

The `:a_step` command allows dynamic execution of analysis step classes like:

```ruby
# Regular steps:

Analysis::PredictionCommand
ProScore::BouncedCheckCommand
Provenir::BigDataCorpCommand
BoaVista::AcertaEssencialCommand
PrePredictionCommand
```

---
---

### Analysis Step Processing Flow ###

Step-by-Step Process:

**Step Discovery**:

```ruby
# app/commands/analysis/step_by_step_command.rb

Analysis::Step.enabled.order(:index_order).each do |enabled_step|
  # Logic of running a step
end
```

```ruby
# app/commands/analysis/next_step_command.rb

def find_analysis_step(command_class)
  Analysis::Step.find_by(command_class: command_class)
end
```

**Step Execution**:

```ruby
Invoker.execute(:a_step, current_item, command_class)
```

**Result Handling in NextAnalysisStep**:

* Approved results continue to next step;
* Disapproved results trigger predictions or error handling.

**Status Updates**:

Item and step execution statuses are updated throughout.

**Feature Updates**:

Model features updated for prediction commands. When `Analysis::PredictionCommand` is called, a features hash is sent to the external prediction application.

The feature hash is built by a method of the analysis item called `Featurable#featurable` - mixin made with module `Featurable` within `Analysis::Item` model.

**Do not change featurable method, unless you know how it is processed by the prediction application. The order of the features matters!**

When the prediction is made, the features are saved:

```ruby
# app/commands/analysis/step_by_step_command.rb
# app/commands/analysis/next_step_command.rb

# Update the steps data and features of the analysis item to latest values.
update_model_features_and_steps_data(enabled_step.command_class)

# [...]

def update_model_features_and_steps_data(command_class)
  if analysis_item.done? && command_class == 'Analysis::PredictionCommand'
    update_features
  end

  update_steps_data
end

def update_steps_data
  steps_data = analysis_item.steps_summary
  analysis_item.update(steps_data:)
end

def update_features
  features = analysis_item.featurable
  analysis_item.update(features:)
end
```

**Webhook Integration**:

`Api::WebhookEvent` tracks all analysis operations and it is useful to check interactions between the caller apps (alpop-api, alpop-saas-api) and the callee (alpop-analysis).

* Status updates: received → processing → processed / error
* Error status is set when all retries are done.
* Both Faraday (gem responsible to make http requests) and Sidekiq (responsible to manage asynchronous jobs) are set up to retry when a request fails.
* Currently Faraday retries 9 times and Sidekiq retries 5 times (in production).
* Sidekiq will retry once, and each Sikideq retry corresponds to 9 retries of Faraday.
* Webhook notifications sent upon completion

---
---

### Architecture Guiding Principles ###

This architecture is built following the engineering principles below:

**Scalability**: Background job processing with Redis/Sidekiq;

**Reliability**: Proper error handling and retry mechanisms;

**Modularity**: Command pattern allows easy addition of new analysis steps;

**Traceability**: Webhook integration for external system notifications within Alpop microservices;

**Flexibility**: Dynamic step execution based on configuration of `StepByStep` and `NextAnalysisStep` endpoints.

---
---

### Error Handling ###

Each endpoint includes comprehensive error handling:

* Invalid parameters return appropriate HTTP status codes;
* Failed jobs are retried with exponential backoff:

```ruby
  # snippet of app/integrators/concerns/integrable.rb
  # it corresponds to the rescue section of the do_request method.

 if should_retry?(e, url, verb) && retries <= MAX_RETRIES
    logger = Logger.new($stdout)
    logger.info(
      <<~LOG
        Retrying Faraday request (attempt #{retries} of #{MAX_RETRIES});
        Sleeping #{calculate_jittered_exponential_backoff(retries)} seconds
        Exception: #{e}
      LOG
    )

    sleep calculate_jittered_exponential_backoff(retries)
    retry
  end

  def should_retry?(exception, _url = nil, _verb = nil)
    return false if AlpopAnalysis.test?

    # Comment out if idempotency logic is breaking:
    # return false if url.include?('alpop.com.br') && verb == :post

    [
      Faraday::ConnectionFailed,
      Faraday::TimeoutError,
      Faraday::ServerError
    ].any? { |error| exception.is_a?(error) }
  end

  def calculate_jittered_exponential_backoff(retry_count)
    # Exponential backoff with decorrelated jitter: min(1s * 2^(retry_count - 1), 30s) * rand(0.5..1.5)
    base_wait = RETRY_WAIT * (2**(retry_count - 1)) # Exponential backoff
    max_wait = 30 # Hard ceiling for wait time to prevent waiting too long
    [base_wait, max_wait].min * rand(0.5..1.5) # Decorrelated jitter between 0.5 and 1.5
  end
```

* Webhook events track processing status for debugging. The main column sent to the caller app (currently alpop-api or alpop-saas-api) is the `payload` of type `jsonb` column:

```ruby
# Analysis::Report.last.api_webhook_event.attributes

{"id" => 39,
 "callback_url" => "http://localhost:3000/api/v2/score-report-webhooks",
 "callback_id" => 45,
 "event_type" => "analysis_report",
 "analysis_report_id" => 39,
 "job_id" => "2bf885bd302f4960e6d5ae8a",
 "status" => "processed",
 "payload" => { "foo" => "bar" }
 "response" => 200,
 "api_client_id" => 9,
 "created_at" => 2025-06-10 13:52:48.971188 UTC,
 "updated_at" => 2025-06-10 14:11:00.989995 UTC,
 "requester" => "guarantor"}
```

* Analysis items maintain detailed execution logs with the junction object `item_steps`:

```ruby
# Example of Analysis::Item.last.item_steps.last.serialize_record

=> {id: 110,
 execution_status: "completed",
 result_summary: {"approved" => true, "disapproval_situation" => nil},
 started_at: 2025-06-10 14:10:49.652052 UTC,
 finished_at: 2025-06-10 14:10:59.986935 UTC,
 duration: 10.328197137,
 created_at: 2025-06-10 14:10:49.646399 UTC,
 updated_at: 2025-06-10 14:10:59.987993 UTC,
 analysis_item_id: 32,
 analysis_step_id: 2}
```
