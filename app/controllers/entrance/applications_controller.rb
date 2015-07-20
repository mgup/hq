class Entrance::ApplicationsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant,
                              through: :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :entrant, class: 'Entrance::Application'

  # Отправка заявления в приказ, то есть зачислени абитуриента.
  #
  # Это выведено в отдельное действие, потому в процессе происходит не только
  # создание определённого приказа, но и проверка, что подобных неподписанных
  # приказов больше нет. Если же находятся подобные приказы, то, вместо создания
  # нового, абитуриент добавляется в уже существующий приказ.
  def send_to_order

  end

  # То, что ниже, нужно рефакторить.
  # ================================

  def index
    # Проверяем созданные заявления на предмет наличия оригинала.
    @has_original = false
    @applications.each do |a|
      @has_original = true if a.original?
    end
    @new_applications = []

    if @campaign.id == 52015
      @campaign.competitive_groups.each do |g|
        found = false
        @entrant.applications.each do |a|
          # Только для неотозванных заявлений.
          if a.called_back?
            next
          else
            found = true if a.competitive_group_item_id == g.items.first.id
          end
        end
        unless found
          # Эта конкурсная группа подходит.
          if g.items.first.budget?
            item = g.items.first
            if (item.number_budget_o > 0 || item.number_quota_o > 0)
              @new_applications << @entrant.applications.build(
                competitive_group_item_id: item.id,
                campaign_id: @campaign.id,
                is_payed: false,
                education_form_id: 11
              )
            end
            if (item.number_budget_oz > 0 || item.number_quota_oz > 0)
              @new_applications << @entrant.applications.build(
                competitive_group_item_id: item.id,
                campaign_id: @campaign.id,
                is_payed: false,
                education_form_id: 12
              )
            end
            if (item.number_budget_z > 0  || item.number_quota_z > 0)
              @new_applications << @entrant.applications.build(
                competitive_group_item_id: item.id,
                campaign_id: @campaign.id,
                is_payed: false,
                education_form_id: 10
              )
            end
          end
          if g.items.first.payed?
            @new_applications << @entrant.applications.build(
                competitive_group_item_id: g.items.first.id,
                campaign_id: @campaign.id,
                is_payed: true
            )
          end
        end
      end
    else
      # Находим все подходящие конкурсные группы.
      entrant_exams = @entrant.exam_results.map { |r| r.exam_id }.sort
      possible_exams = []
      (1..entrant_exams.size).each do |n|
        entrant_exams.combination(n).to_a.each do |combination|
          possible_exams << combination.sort
        end
      end
      possible_exams.uniq!


      @campaign.competitive_groups.each do |g|
        needed_exams = g.test_items
        possible_exams.each do |combination|
          if combination == needed_exams.map { |i| i.exam_id }.sort
            key = true
            needed_exams.each do |exam|
              key &&= (@entrant.exam_results.by_exam(exam.exam_id).first.score ? exam.min_score <= @entrant.exam_results.by_exam(exam.exam_id).first.score : true)
            end
            found = !key
            # @entrant.applications.each do |a|
            #   # Только для неотозванных заявлений.
            #   if a.called_back?
            #     # Проверяем, что у человека ещё нет заявлений в этой конкурсной группе.
            #     next
            #   else
            #     found = true if a.competitive_group_item_id == g.items.first.id
            #   end
            # end

            unless found
              # Эта конкурсная группа подходит.
              # @new_applications << @entrant.applications.build(
              #   competitive_group_item_id: g.items.first.id,
              #   campaign_id: @campaign.id
              # )
              item = g.items.first

              if item.budget?
                if (item.number_budget_o > 0 || item.number_quota_o > 0)
                  @new_applications << @entrant.applications.build(
                    competitive_group_item_id: item.id,
                    campaign_id: @campaign.id,
                    is_payed: false,
                    education_form_id: 11
                  )
                end
                if (item.number_budget_oz > 0 || item.number_quota_oz > 0)
                  @new_applications << @entrant.applications.build(
                    competitive_group_item_id: item.id,
                    campaign_id: @campaign.id,
                    is_payed: false,
                    education_form_id: 12
                  )
                end
                if (item.number_budget_z > 0  || item.number_quota_z > 0)
                  @new_applications << @entrant.applications.build(
                    competitive_group_item_id: item.id,
                    campaign_id: @campaign.id,
                    is_payed: false,
                    education_form_id: 10
                  )
                end
              end
              if item.payed?
                if (item.number_paid_o > 0)
                  @new_applications << @entrant.applications.build(
                    competitive_group_item_id: item.id,
                    campaign_id: @campaign.id,
                    is_payed: true,
                    education_form_id: 11
                  )
                end
                if (item.number_paid_oz > 0)
                  @new_applications << @entrant.applications.build(
                    competitive_group_item_id: item.id,
                    campaign_id: @campaign.id,
                    is_payed: true,
                    education_form_id: 12
                  )
                end
                if (item.number_paid_z > 0)
                  @new_applications << @entrant.applications.build(
                    competitive_group_item_id: item.id,
                    campaign_id: @campaign.id,
                    is_payed: true,
                    education_form_id: 10
                  )
                end
              end
            end
          else
            next
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

  def new ; end

  def create
    if @application.save
      # Теперь нужно заявлению присвоить номер.
      number = '15-'
      number << @application.competitive_group_item.direction.letters

      second = case @application.competitive_group_item.direction.qualification_code
               when 68
                 'М'
               when 70
                 'А'
               else case @application.education_form_id
                    when 10
                      'З'
                    when 11
                      'Д'
                    when 12
                      'В'
                    else
                      fail 'Кажется, что-то пошло не так.'
                    end
               end

      number << (@application.entrant.ioo ? 'И' : second)

      payment = @application.is_payed ? 'п' : ''

      last = Entrance::Application.
        where('number LIKE ?', "#{number}%#{payment}")
        .order(number: :desc).first
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
          redirect_to entrance_campaign_entrant_applications_path(
                        @application.campaign,
                        @application.entrant
                      ),
                      notice: 'Заявление успешно создано.'
        end
        format.js
      end
    else
      render action: :new
    end
  end

  # Отклонение заявления. Для тех, кто не прошел по конкурсу и т.д.
  def reject
    @application.status_id = 5
    @application.save!

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @application.status_id = 6
    @application.last_deny_date = Date.today
    @application.save!

    redirect_to entrance_campaign_entrant_applications_path(
                  @application.campaign,
                  @application.entrant
                ),
                notice: 'Заявление успешно отозвано.'
  end

  def enroll
    @application.enroll
    respond_to { |format| format.js }
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
      :competitive_group_item_id, :packed, :status_id, :created_at, :updated_at, :is_payed,
      :education_form_id
    )
  end
end
