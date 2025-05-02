# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :bigint           not null, primary key
#  cpf                   :string
#  disapproval_situation :integer
#  error_status          :integer          default("none")
#  features              :jsonb
#  name                  :string
#  status                :integer          default("todo")
#  steps_data            :jsonb            not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  analysis_report_id    :bigint           not null
#  clone_of_id           :bigint
#
# Indexes
#
#  index_analysis_items_on_analysis_report_id  (analysis_report_id)
#  index_analysis_items_on_clone_of_id         (clone_of_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_report_id => analysis_reports.id)
#  fk_rails_...  (clone_of_id => analysis_items.id)
#
FactoryBot.define do
  factory :analysis_item, class: 'Analysis::Item' do
    name { Faker::Name.name }
    cpf { Faker::CPF.pretty }
    status { %i[todo wip done not_found error].sample }
    features do
      {
        provenir_age: 28,
        provenir_total_phones: 0,
        provenir_total_addresses: nil,
        provenir_tax_returns_count: 0,
        provenir_total_assets_class: 1,
        provenir_presumed_income_class: 1,
        provenir_collection_occurrences: 0,
        provenir_business_total_partners: 0,
        provenir_business_total_ownerships: 0,
        provenir_business_total_employments: 0,
        provenir_business_total_relationships: 0,
        boa_vista_acerta_essencial_debits_total_value: 0,
        boa_vista_acerta_essencial_debit_with_maximum_value: nil,
        boa_vista_acerta_essencial_debit_with_minimum_value: nil,
        boa_vista_acerta_essencial_days_since_the_last_debit: nil,
        boa_vista_acerta_essencial_protested_titles_total_value: 0,
        boa_vista_acerta_essencial_protested_title_with_maximum_value: nil,
        boa_vista_acerta_essencial_protested_title_with_minimum_value: nil,
        boa_vista_acerta_essencial_days_since_the_last_protested_title: nil
      }
    end
    error_status do
      %i[
        none idwall boa_vista pro_score_trials serasa
        pro_score_family_holdings pro_score_bounced_checks
        pro_score_presumed_income pro_score_commercial_relations
        provenir_big_data_corp alpop_prediction
      ].sample
    end

    report factory: %i[analysis_report]

    Analysis::Item.statuses.each_key do |status|
      trait status.to_sym do
        status { status }
      end
    end

    trait :clone do
      clone_of factory: :analysis_item
    end

    trait :blocked_cpf do
      status { :done }
      disapproval_situation { :blocked_cpf }
    end

    trait :reproved_by_trial do
      status { :done }
      disapproval_situation { :reproved_by_trial }
    end

    trait :blocked_negativity do
      status { :done }
      disapproval_situation { :blocked_negativity }
    end

    trait :debtor do
      status { :done }
      disapproval_situation { :debtor }
    end

    trait :insufficient_income do
      status { :done }
      disapproval_situation { :insufficient_income }
    end

    trait :exceeded_debits do
      status { :done }
      disapproval_situation { :exceeded_debits }
    end

    trait :reproved_by_relative do
      status { :done }
      disapproval_situation { :reproved_by_relative }
    end

    trait :reproved_by_bounced_check do
      status { :done }
      disapproval_situation { :reproved_by_bounced_check }
    end

    trait :reproved_by_age_and_income do
      status { :done }
      disapproval_situation { :reproved_by_age_and_income }
    end

    trait :with_analysis_associations do
      after(:create) do |analysis_item|
        create :provenir_big_data_corp, analysis_item: analysis_item
        create :pro_score_report, analysis_item: analysis_item
        create :boa_vista_acerta_essencial, consumer: analysis_item
        create :boa_vista_cadastral, consumer: analysis_item
        create :serasa_fintech_report, owner: analysis_item
        create :idwall_report, analysis_item: analysis_item
      end
    end

    trait :with_steps do
      after(:create) do |item|
        analysis_steps = create_list :analysis_step, 3

        analysis_steps.each do |step|
          create :analysis_item_step, item: item, step: step
        end

        item.item_steps.each do |item_step|
          item_step.update(execution_status: :completed)
        end
      end
    end
  end
end
