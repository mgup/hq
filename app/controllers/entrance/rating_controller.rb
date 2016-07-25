class Entrance::RatingController < ApplicationController
  def index
    authorize! :manage, Entrance::Entrant

    @campaign = Entrance::Campaign.find_by(id: params[:id])
    load_directions

    @applications = @campaign.applications.for_rating.rating(params[:form],
                                                             params[:payment],
                                                             params[:direction])
    init_applications
  end

  private

  def load_directions
    @directions = Entrance::Campaign.where(start_year: Entrance::Campaign::CURRENT_YEAR).
      includes(competitive_groups: :items).
      map(&:competitive_groups).sum.map(&:items).sum.map(&:direction).uniq.sort_by do |d|
      [d.bachelor? || d.specialist? ? 1 : 2, d.master? ? 1 : 2, d.name]
    end
  end

  def init_applications
    @exam_names = {}
    @exam_names_crimea = {}

    @out_of_competition = []
    @crimea = []
    @special_rights = []
    @organization = []
    @contest = []

    @applications.each do |a|
      @out_of_competition << a if a.out_of_competition?

      next unless 0 != a.pass_min_score

      exams = a.competitive_group.test_items.order(:entrance_test_priority).map { |t| t.exam.name }
      if a.competitive_group.name.include?('Крым')
        @crimea << a
        exams.each_with_index do |name, i|
          if @exam_names_crimea[i].present?
            @exam_names_crimea[i] += " <hr> #{name}" unless @exam_names_crimea[i].include?(name)
          else
            @exam_names_crimea[i] = name
          end
        end
      else
        if a.special_rights?
          @special_rights << a
        elsif a.competitive_group_target_item.present?
          @organization << a
        else
          @contest << a
        end

        exams.each_with_index do |name, i|
          if @exam_names[i].present?
            @exam_names[i] += " <hr> #{name}" unless @exam_names[i].include?(name)
          else
            @exam_names[i] = name
          end
        end
      end
    end

    @exam_names[@exam_names.size] = 'Индивидуальные достижения'
    @exam_names_crimea[@exam_names_crimea.size] = 'Индивидуальные достижения'
  end
end
