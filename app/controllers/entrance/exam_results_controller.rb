class Entrance::ExamResultsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant, throught: :campaign,
                              class: 'Entrance::Entrant', except: :ajax_update
  load_and_authorize_resource through: :entrant, class: 'Entrance::ExamResult', except: :ajax_update
  load_and_authorize_resource :exam, throught: :campaign,
                              class: 'Entrance::Exam', only: :ajax_update
  load_and_authorize_resource through: :exam, class: 'Entrance::ExamResult', only: :ajax_update

  def index

  end

  def ajax_update
    @exam_result.update_attribute(:score, params[:result])
    render({ json: {id: @exam_result.id, score: @exam_result.score} })
  end

  def resource_params
    params.fetch(:entrance_exam_result, {}).permit(:id, :exam_id, :form, :score,
                                  :document, :entrant_id, :created_at, :updated_at
    )
  end

end