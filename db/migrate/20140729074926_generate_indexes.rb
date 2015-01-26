class GenerateIndexes < ActiveRecord::Migration
  def change
    add_index :entrance_applications, :entrant_id
    add_index :entrance_applications, :status_id
    add_index :entrance_applications, :campaign_id
    add_index :entrance_applications, :package_id
    add_index :entrance_applications, :competitive_group_target_item_id

    add_index :entrance_benefits, :benefit_kind_id
    add_index :entrance_benefits, :document_type_id

    add_index :entrance_contracts, :application_id

    add_index :entrance_dates, :campaign_id
    add_index :entrance_dates, :education_form_id
    add_index :entrance_dates, :education_type_id
    add_index :entrance_dates, :education_source_id

    add_index :entrance_document_movements, :from_application_id
    add_index :entrance_document_movements, :to_application_id

    add_index :entrance_edu_documents, :document_type_id
    add_index :entrance_edu_documents, :qualification_type_id
    add_index :entrance_edu_documents, :direction_id
    add_index :entrance_edu_documents, :specialization_id
    add_index :entrance_edu_documents, :profession_id
    add_index :entrance_edu_documents, :entrant_id

    add_index :entrance_entrants, :campaign_id
    add_index :entrance_entrants, :identity_document_type_id
    add_index :entrance_entrants, :nationality_type_id
    add_index :entrance_entrants, :student_id

    add_index :entrance_event_entrants, :entrance_event_id
    add_index :entrance_event_entrants, :entrance_entrant_id

    add_index :entrance_events, :campaign_id

    add_index :entrance_exams, :campaign_id
    add_index :entrance_exams, :use_subject_id

    add_index :entrance_logs, :user_id

    add_index :entrance_min_scores, :campaign_id
    add_index :entrance_min_scores, :direction_id
    add_index :entrance_min_scores, :education_source_id
    add_index :entrance_min_scores, :entrance_exam_id

    add_index :entrance_papers, :entrance_entrant_id

    add_index :entrance_test_items, :use_subject_id

    add_index :entrance_use_check_results, :exam_result_id
    add_index :entrance_use_check_results, :use_check_id

    add_index :entrance_use_checks, :entrant_id
  end
end
