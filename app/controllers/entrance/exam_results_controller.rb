module Entrance
  class ExamResultsController < ApplicationController
    load_and_authorize_resource :campaign,
                                class: 'Entrance::Campaign'
    load_and_authorize_resource :exam,
                                through: :campaign,
                                class: 'Entrance::Exam'
    load_and_authorize_resource through: :exam,
                                class: 'Entrance::ExamResult'

    # Результаты внутренних вступительных испытаний, проводимых вузом
    # самостоятельно.
    def index
      @exam_results = @exam_results.internal
    end

    def ajax_update
      @exam_result.update_attribute(:score, params[:result])
      render(json: { id: @exam_result.id, score: @exam_result.score })
    end

    def resource_params
      params.fetch(:entrance_exam_result, {}).permit(
        :id, :exam_id, :form, :score, :document, :entrant_id,
        :created_at, :updated_at
      )
    end
  end
end
