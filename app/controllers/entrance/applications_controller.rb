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
          found = false
          @entrant.applications.each do |a|
            if a.competitive_group_item_id == g.items.first.id
              found = true
            end
          end

          unless found
            # Эта конкурсная группа подходит.
            @entrant.applications.build(
              competitive_group_item_id: g.items.first.id,
              campaign_id: @campaign.id)
          end
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.xml { render xml: @application.to_fis.to_xml }
    end
  end

  def new

  end

  def create
    if @application.save
      # Теперь нужно заявлению присвоить номер.
      number = '14-'
      number << @application.competitive_group_item.direction.letters

      number << case @application.competitive_group_item.direction.qualification_code
                  when '68'
                    'М'
                  when '70'
                    'А'
                  else case @application.competitive_group_item.form
                         when 10
                           'З'
                         when 11
                           'Д'
                         when 12
                           'В'
                         else
                           raise 'Кажется, что-то пошло не так.'
                       end
                end

      payment = @application.competitive_group_item.payed? ? 'п' : ''

      last = Entrance::Application.
        where('number LIKE ?', "#{number}%#{payment}").
        order(number: :desc).first
      if last
        last_number = last.number
        last_number.slice!(number)
        last_number.slice!(payment)

        count = last_number.to_i + 1
      else
        count = 1
      end

      number << sprintf('%03d', count)
      number << payment

      @application.number = number
      @application.save!

      respond_to do |format|
        format.html do
          redirect_to entrance_campaign_entrants_path(@campaign),
                      notice: 'Абитуриент успешно добавлен.'
        end
        format.js
      end
    else
      render action: :new
    end
  end

  def print
    respond_to { |format| format.pdf }
  end

  def print_all
    respond_to { |format| format.pdf }
  end

  def resource_params
    params.fetch(:entrance_application, {}).permit(
      :entrant_id, :number, :original, :registration_date, :campaign_id,
      :competitive_group_item_id
    )
  end
end