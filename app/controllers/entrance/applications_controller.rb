class Entrance::ApplicationsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant, through: :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :entrant, class: 'Entrance::Application'

  def index
    # Находим все подходящие конкурсные группы.
    entrant_exams = @entrant.exam_results.map { |r| r.exam_id }.sort
    possible_exams = []
    (1..entrant_exams.size).each do |n|
      entrant_exams.combination(n).to_a.each do |combination|
        possible_exams << combination.sort
      end
    end
    possible_exams.uniq!

    Entrance::CompetitiveGroup.all.each do |g|
      needed_exams = g.test_items.map { |i| i.exam_id }

      possible_exams.each do |combination|
        if combination == needed_exams.sort
          # Эта конкурсная группа подходит.
          @entrant.applications.build(competitive_group_item_id: g.items.first.id)
        end
      end
    end
  end

  def new

  end

  def create

  end

  def print
    @entrant = @application.entrant
    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.fetch(:application, {}).permit(
      :number, :registration_date
    )
  end
end