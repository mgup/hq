class Entrance::ExamsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :campaign, class: 'Entrance::Exam'

  def update
    # raise resource_params.inspect
    @exam.update(resource_params)
    redirect_to results_entrance_campaign_path id: @campaign, exam: @exam.id
  end

  def resource_params
    params.fetch(:entrance_exam, {}).permit( :id, :campaign_id, :use, :use_subject_id, :name, :visible,
                                                exam_results_attributes: [:id, :entrant_id, :score, :form, :document, :created_at, :updated_at]
    )
  end

end