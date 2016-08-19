class Entrance::RatingController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]

  def index
    @campaign = Entrance::Campaign.find_by(id: params[:id])
    load_directions
    init_places

    @applications = @campaign.applications.for_rating.rating(params[:form],
                                                             params[:payment],
                                                             params[:direction])
    init_applications
  end

  private

  def load_directions
    @direction = Direction.find_by(id: params[:direction])

    @directions = @campaign.competitive_groups.includes(items: :direction).map(&:items).sum.map(&:direction).uniq.sort_by do |d|
      [d.bachelor? || d.specialist? ? 1 : 2, d.master? ? 1 : 2, d.name]
    end
  end

  def init_applications
    @exam_names = {}
    @exam_names_crimea = {}
    @exam_names_foreign = {}

    @out_of_competition = []
    @crimea = []
    @crimea_enrolled = []
    @foreign = []
    @foreign_enrolled = []
    @special_rights = []
    @organization = []
    @organization_contest = []
    @contest_enrolled = []
    @contest_preenrolled = []
    @contest = []

    @applications.each do |a|
      # next if a.competitive_group.name.include?('иностранцы')
      if a.out_of_competition?
        @out_of_competition << a
        next
      end

      next unless 0 != a.pass_min_score

      exams = a.competitive_group.test_items.order(:entrance_test_priority).map { |t| t.exam.name }
      if a.competitive_group.name.include?('Крым')
        if a.order_id.present?
          @crimea_enrolled << a
        else
          @crimea << a
        end
        exams.each_with_index do |name, i|
          if @exam_names_crimea[i].present?
            @exam_names_crimea[i] += " <hr> #{name}" unless @exam_names_crimea[i].include?(name)
          else
            @exam_names_crimea[i] = name
          end
        end
      elsif a.competitive_group.name.include?('иностранцы')
        if a.order.present? && a.order.signing_date.present?
          @foreign_enrolled << a
        else
          @foreign << a
        end
        exams.each_with_index do |name, i|
          if @exam_names_foreign[i].present?
            @exam_names_foreign[i] += " <hr> #{name}" unless @exam_names_foreign[i].include?(name)
          else
            @exam_names_foreign[i] = name
          end
        end
      else
        if a.special_rights?
          @special_rights << a if a.order_id.present?
        elsif a.competitive_group_target_item.present?
          @organization << a if a.order.present?
          @organization_contest << a
        else
          if a.order.present? && a.order.signing_date.present?
            @contest_enrolled << a
          elsif a.order.present?
            @contest_preenrolled << a
          else
            @contest << a
          end
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
    @exam_names_foreign[@exam_names_foreign.size] = 'Индивидуальные достижения'
  end

  def init_places
    @total_places = 0
    @crimea_places = 0
    @foreign_places = 0
    @quota_places = 0
    @target_places = 0

    form = case params[:form]
           when '10' then :z
           when '11' then :o
           when '12' then :oz
           end

    payment = case params[:payment]
              when '14' then :budget
              when '15' then :paid
              end

    @direction.competitive_group_items.joins(:competitive_group)
      .where('competitive_groups.campaign_id = ?', @campaign.id).each do |gi|
      g = gi.competitive_group

      next unless @campaign.id == g.campaign_id

      @total_places += gi.send("number_#{payment}_#{form}")

      if g.name.include?('Крым')
        @crimea_places += gi.send("number_#{payment}_#{form}")
      end

      if g.name.include?('иностранцы')
        @foreign_places += gi.send("number_#{payment}_#{form}")
      end

      @total_places += gi.send("number_quota_#{form}")
      @quota_places += gi.send("number_quota_#{form}")


      if g.target_organizations.any?
        t = g.target_organizations.map(&:items).sum.find_all { |i| i.direction.description == @direction.description }.map(&"number_target_#{form}".to_sym).sum
        @total_places += t
        @target_places += t
      end
    end
  end
end
