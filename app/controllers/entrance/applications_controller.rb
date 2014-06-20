class Entrance::ApplicationsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant, through: :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :entrant, class: 'Entrance::Application'

  def index
    # Находим все подходящие конкурсные группы.
    entrant_exams = @entrant.exam_results.map { |r| r.exam_id }.sort

    Entrance::CompetitiveGroup.all.each do |g|
      needed_exams = g.test_items.map { |i| i.exam_id }

      if entrant_exams == needed_exams.sort
        # Эта конкурсная группа подходит.
        @entrant.applications.build(competitive_group_item_id: g.items.first.id)
      end
    end
  end

  def new

  end

  def create

  end

  def resource_params
    params.fetch(:application, {}).permit(
      :number, :registration_date
    )
  end
end