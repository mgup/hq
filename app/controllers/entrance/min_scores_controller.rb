class Entrance::MinScoresController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  load_resource :campaign, class: 'Entrance::Campaign'
  load_resource through: :campaign, class: 'Entrance::Date'

  def index
    directions = []
    @subjects_budget = []
    @rows_budget = []
    @campaign.min_scores.budget.each do |ms|
      directions << ms.direction
      @subjects_budget << ms.exam
    end
    directions.uniq!
    @subjects_budget.uniq!
    directions.each do |direction|
      row = []
      row << direction.name
      @subjects_budget.each do |subject|
        row << (@min_scores.budget.by_direction(direction).by_exam(subject).empty? ? nil : @min_scores.budget.by_direction(direction).by_exam(subject).first.score)
      end
      @rows_budget << row
    end

    @rows_paid = []
    directions = []
    @subjects_paid = []
    @campaign.min_scores.paid.each do |ms|
      directions << ms.direction
      @subjects_paid << ms.exam
    end
    directions.uniq!
    @subjects_paid.uniq!
    directions.each do |direction|
      row = []
      row << direction.name
      @subjects_paid.each do |subject|
        row << (@min_scores.paid.by_direction(direction).by_exam(subject).empty? ? nil : @min_scores.paid.by_direction(direction).by_exam(subject).first.score)
      end
      @rows_paid << row
    end
  end
end