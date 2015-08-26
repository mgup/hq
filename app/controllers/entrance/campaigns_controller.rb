class Entrance::CampaignsController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:applications, :balls, :rating, :crimea_rating]
  skip_before_action :authenticate_user!, only: [:applications, :balls, :report] #, :rating]#, if: :format_html?
  load_and_authorize_resource class: 'Entrance::Campaign', except: [:results, :report]
  load_resource class: 'Entrance::Campaign', only: :results

  #before_action :validate_crimea, only: [:rating]

  before_action :initialize_default_filters, only: [:dashboard, :rating, :crimea_rating]

  def format_html?
    request.format.html?
  end


  def choice

  end

  # Заявления.
  # def dashboard
  #   fail '123'
  #   @items = Entrance::CompetitiveGroupItem.find(@applications.collect{ |app| app.competitive_group_item_id }.uniq)
  # end

  def validate_crimea
    @campaign = Entrance::Campaign.find(32015) unless signed_in?
  end

  # Пофамильные списки поступающих (рейтинги).
  def rating
    # if user_signed_in?
      @items = Entrance::CompetitiveGroupItem.find(@applications.collect{ |app| app.competitive_group_item_id }.uniq)
    # else
    #   render 'entrance/campaigns/rating_hidden'
    # end
  end

  def crimea_rating
    items = Entrance::CompetitiveGroupItem.find(@applications.collect{ |app| app.competitive_group_item_id }.uniq)
    if @applications.take
      @number = items.collect { |i| i.total_number }.sum
    end
  end

  def applications
    params[:direction] ||= 1887

    @applications = applications_from_filters.actual

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def orders
    @orders = Office::Order.entrance.from_year_and_month(2015, 6)
  end

  def numbers

  end

  def print_all
    @department = Department.find(params[:department]) if params[:department]
    @for_aspirants = true if params[:aspirants]
    respond_to do |format|
      format.pdf
    end
  end

  def print_department_register
    @department = Department.find(params[:department])
    @apps = @campaign.applications.actual.where('DATE(entrance_applications.created_at) = ?',
                 Date.strptime(params[:date], '%d.%m.%Y')).from_faculty(params[:department])

    respond_to do |format|
      format.pdf
    end
  end

  def results
    authorize! :manage, Entrance::Exam

    if params[:exam]
      found = false
      @campaign.exams.each do |exam|
        found = true if exam.id == params[:exam].to_i
      end
      params[:exam] = @campaign.exams.first.id unless found
    else
      params[:exam] ||= @campaign.exams.first.id
    end

    @exam = Entrance::Exam.find(params[:exam])
    @entrants = Entrance::Entrant.from_exam(params[:exam])
      .order(:last_name, :first_name, :patronym)

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def balls
    if params[:exam]
      found = false
      @campaign.exams.each do |exam|
        found = true if exam.id == params[:exam].to_i
      end
      if @campaign.exams.any?
        params[:exam] = @campaign.exams.first.id unless found
      end
    else
      params[:exam] ||= @campaign.exams.first.id
    end

    @exam = Entrance::Exam.find(params[:exam])
    @entrants = Entrance::Entrant.from_exam(params[:exam]).
      order(:last_name, :first_name, :patronym)
  end

  def report
    #.
      # find_all { |a| [11, 12].include?(a.form) && !a.payed? && %w(03 05).include?(a.direction.new_code.split('.')[1]) && 32014 != a.campaign.id }

    respond_to do |format|
      format.html do
        @campaign_year = Entrance::Campaign::CURRENT

        @applications = []

        competitive_group_titles = { o: {}, z: {} }

        Entrance::Campaign.where(start_year: @campaign_year).each do |campaign|
          @applications += campaign.applications.includes(competitive_group_item: :direction).actual#.first(100)

          campaign.competitive_groups.each do |competitive_group|
            title = "#{competitive_group.items.first.direction.new_code} #{competitive_group.name}"
            if competitive_group.items.first.total_budget_o > 0 || competitive_group.items.first.total_paid_o > 0
              competitive_group_titles[:o][title] = competitive_group.items.first
            end
            if competitive_group.items.first.total_budget_oz > 0 || competitive_group.items.first.total_paid_oz > 0
              competitive_group_titles[:o][title] = competitive_group.items.first
            end
            if competitive_group.items.first.total_budget_z > 0 || competitive_group.items.first.total_paid_z > 0
              competitive_group_titles[:z][title] = competitive_group.items.first
            end
          end
        end

        by_competitive_group = @applications.group_by do |a|
          # a.competitive_group
          title = "#{a.competitive_group.items.first.direction.new_code} #{a.competitive_group.name}"

          # case a.education_form_id
          # when 11
          #   competitive_group_titles[:o][title] = a.competitive_group.items.first
          # when 12
          #   competitive_group_titles[:o][title] = a.competitive_group.items.first
          # when 10
          #   competitive_group_titles[:z][title] = a.competitive_group.items.first
          # else
          #   fail 'Неизвестная форма обучения.'
          # end

          title
        end

        data_draft = []
        by_competitive_group.each do |competitive_group_title, applications|
          d = [
            competitive_group_title,
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0]
          ]

          if competitive_group_titles[:o][competitive_group_title]
            competitive_group_item = competitive_group_titles[:o][competitive_group_title]
            d[1][2] = competitive_group_item.total_budget_o
            competitive_group_item.competitive_group.target_organizations.each do |org|
              org.items.where(direction_id: competitive_group_item.direction_id, education_level_id: competitive_group_item.education_type_id).each do |i|
                d[1][2] += i.send("number_target_o")
              end
            end

            d[2][2] = competitive_group_item.total_paid_o
            d[3][2] = competitive_group_item.total_paid_oz
          end

          if competitive_group_titles[:z][competitive_group_title]
            competitive_group_item = competitive_group_titles[:z][competitive_group_title]
            d[4][2] = competitive_group_item.total_paid_z
          end

          applications.each do |application|
            if application.is_payed
              case application.education_form_id
              when 11
                d[2][0] += 1
                d[2][1] += 1 if application.contract
                d[2][3] += 1 if application.order_id
              when 12
                d[3][0] += 1
                d[3][1] += 1 if application.contract
                d[3][3] += 1 if application.order_id
              when 10
                d[4][0] += 1
                d[4][1] += 1 if application.contract
                d[4][3] += 1 if application.order_id
              else
                fail 'Неизвестная форма обучения.'
              end
            else
              d[1][0] += 1
              d[1][1] += 1 if application.original?
              d[1][3] += 1 if application.order_id
            end
          end

          data_draft << d
        end

        data_draft.each do |row|
          if row[1][2] > 0
            row[1][4] = (1.0 * row[1][0] / row[1][2]).round(2)
            row[1][5] = (1.0 * row[1][1] / row[1][2]).round(2)
          end
          if row[2][2] > 0
            row[2][4] = (1.0 * row[2][0] / row[2][2]).round(2)
            row[2][5] = (1.0 * row[2][1] / row[2][2]).round(2)
          end
          if row[3][2] > 0
            row[3][4] = (1.0 * row[3][0] / row[3][2]).round(2)
            row[3][5] = (1.0 * row[3][1] / row[3][2]).round(2)
          end
          if row[4][2] > 0
            row[4][4] = (1.0 * row[4][0] / row[4][2]).round(2)
            row[4][5] = (1.0 * row[4][1] / row[4][2]).round(2)
          end
        end

        @data = data_draft.sort_by do |row|
          parts = row[0].split('.')
          [parts[2][3..(parts[2].rindex('(')||(parts[2].rindex('К'))||(parts[2].size+1))-2], parts[0], parts[1], parts[2][3..-1]]
        end

        last_row = [
          'По всем конкурсным группам',
          [@data.map(&:second).map(&:first).sum, @data.map(&:second).map(&:second).sum, @data.map(&:second).map(&:third).sum, @data.map(&:second).map(&:fourth).sum, 0, 0],
          [@data.map(&:third).map(&:first).sum, @data.map(&:third).map(&:second).sum, @data.map(&:third).map(&:third).sum, @data.map(&:third).map(&:fourth).sum, 0, 0],
          [@data.map(&:fourth).map(&:first).sum, @data.map(&:fourth).map(&:second).sum, @data.map(&:fourth).map(&:third).sum, @data.map(&:fourth).map(&:fourth).sum, 0, 0],
          [@data.map(&:fifth).map(&:first).sum, @data.map(&:fifth).map(&:second).sum, @data.map(&:fifth).map(&:third).sum, @data.map(&:fifth).map(&:fourth).sum, 0, 0]
        ]

        if last_row[1][2] > 0
          last_row[1][4] = (1.0 * last_row[1][0] / last_row[1][2]).round(2)
          last_row[1][5] = (1.0 * last_row[1][1] / last_row[1][2]).round(2)
        end
        if last_row[2][2] > 0
          last_row[2][4] = (1.0 * last_row[2][0] / last_row[2][2]).round(2)
          last_row[2][5] = (1.0 * last_row[2][1] / last_row[2][2]).round(2)
        end
        if last_row[3][2] > 0
          last_row[3][4] = (1.0 * last_row[3][0] / last_row[3][2]).round(2)
          last_row[3][5] = (1.0 * last_row[3][1] / last_row[3][2]).round(2)
        end
        if last_row[4][2] > 0
          last_row[4][4] = (1.0 * last_row[4][0] / last_row[4][2]).round(2)
          last_row[4][5] = (1.0 * last_row[4][1] / last_row[4][2]).round(2)
        end

        @data << last_row
      end
      # format.xlsx do
      #   response.headers['Content-Disposition'] = 'attachment; filename="' +
      #     "Количество поданных заявлений на #{l Time.now}.xlsx" + '"'
      # end
      format.xml do
        # @applications = Entrance::Application.where(campaign_id: [2015, 32015]).
        #   where(status_id: 8).where(is_payed: false).reject { |a| a.direction.master? }
        @applications = Entrance::Application.where(campaign_id: [2015]).
          where(status_id: 8).where(is_payed: false).reject { |a| a.direction.master? }

        doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.PackageData do
            # xml.Applications do
            #   @applications.each do |application|
            #     xml << application.to_fis.xpath('/Application').to_xml.to_str
            #   end
            # end

            order_ids = [33071,33054,33063,33066,33053]

            xml.OrdersOfAdmission do
              @applications.each do |application|
                next if application.order.signing_date == Date.new(2015, 7, 30)

                xml.OrderOfAdmission do
                  xml.OrderOfAdmissionUID "order_of_admission_#{application.order.id}"

                  xml.OrderName application.competitive_group.name
                  xml.OrderNumber application.order.number
                  xml.OrderDate application.order.signing_date.to_date.iso8601

                  xml.Application do
                    xml.ApplicationNumber application.number
                    xml.RegistrationDate application.created_at.iso8601
                    xml.OrderIdLevelBudget 1
                  end
                  xml.DirectionID application.direction.id
                  xml.EducationFormID application.education_form_id

                  if application.benefits.any? && application.order.signing_date == Date.new(2015, 7, 30)
                    xml.FinanceSourceID 20
                    xml.IsBeneficiary true
                  else
                    xml.FinanceSourceID application.is_payed ? 15 : (application.competitive_group_target_item_id.nil? ? 14 : 16)
                    xml.IsBeneficiary false
                  end
                  xml.CompetitiveGroupUID application.competitive_group.id

                  xml.EducationLevelID application.competitive_group_item.education_type_id

                  # unless order_ids.include?(application.order.id)
                    if Date.new(2015, 8, 4) == application.order.signing_date
                      xml.Stage 1
                    elsif Date.new(2015, 8, 7) == application.order.signing_date
                      xml.Stage 2
                    elsif Date.new(2015, 7, 27) == application.order.signing_date
                      xml.Stage 1
                    else
                      xml.Stage 0
                    end
                  # end
                  # order_ids.push(application.order.id)
                end
              end
            end
          end
        end

        render xml: doc.to_xml
      end
    end
  end

  def register
    if params[:date] == ''
      # if params[:faculty] == ''
#         @applications = applications_from_filters
#       else
#         @applications = applications_from_filters(faculty: true)
#       end
      @applications = applications_from_filters
    else
      # if params[:faculty] == ''
#         @applications = applications_from_filters(date: true)
#       else
#         @applications = applications_from_filters(date: true, faculty: true)
#       end
      @applications = applications_from_filters(date: true)
    end

    # if params[:faculty] == ''
#       @directions = Direction.for_campaign(@campaign)
#     else
#       @directions = Direction.for_campaign(@campaign).from_faculty(params[:faculty])
#     end

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def temp_print_all_checks
    params[:faculty] ||= 3 # 5,6,7
    @faculty = Department.find(params[:faculty])

    checks_all = Entrance::UseCheck.all.joins(:entrant).
      joins('LEFT JOIN entrance_applications AS a ON a.entrant_id = entrance_entrants.id').
      where('a.campaign_id = 2015').
      where('a.packed = 1').
      joins('LEFT JOIN competitive_group_items as i ON a.competitive_group_item_id = i.id').
      joins('LEFT JOIN directions AS d ON d.id = i.direction_id').
      where('d.department_id = ?', params[:faculty])

    grouped = checks_all.group_by { |c| c.entrant }

    @checks = []
    grouped.each do |_, checks|
      @checks << checks.sort_by { |c| c.date }.last
    end

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def paid_enrollment
    render_report Entrance::PaidEnrollmentReport.new(Entrance::Campaign::CURRENT)
  end

  # Конфликты при проверке ЕГЭ.
  def conflicts

  end

  # Пофамильные списки поступающих с баллами.
  def ratings
    respond_to do |format|
      format.pdf
    end
  end

  def protocol_permit
    respond_to do |format|
      format.pdf
    end
  end

  private

  # Инициализация фильтров по-умолчанию.
  def initialize_default_filters
    if params[:competitive_group]
      unless @campaign.competitive_groups.map { |g| g.id }.include?(params[:competitive_group].to_i)
        params[:competitive_group] = @campaign.competitive_groups.first.id
      end
    else
      params[:competitive_group] = @campaign.competitive_groups.first.id
    end

    if params[:competitive_group]
      @competitive_group = Entrance::CompetitiveGroup.find(params[:competitive_group])

      @direction = @competitive_group.items.first.direction
      params[:direction] = @direction.id
    else
      params[:direction] ||= 1887
      @direction = Direction.find(params[:direction])
    end

    params[:form] ||= 11
    @form = EducationForm.find(params[:form])

    params[:payment] ||= 14
    @source = EducationSource.find(params[:payment])

    if params[:competitive_group]
      @applications = @competitive_group.items.first.applications.for_rating.rating(params[:form],
                                                               params[:payment],
                                                               params[:direction])
    else
      @applications = @campaign.applications.for_rating.rating(params[:form],
                                                               params[:payment],
                                                               params[:direction])
    end
  end

  def applications_from_filters(opts = { form: true, payment: true, date: false, faculty: false })
    params[:date] ||= l(Date.today)

    params[:form]      ||= 11
    @form = EducationForm.find(params[:form])

    params[:payment]   ||= 14
    @source = EducationSource.find(params[:payment])

    form_method = case params[:form]
                  when '10'
                    :z_form
                  when '12'
                    :oz_form
                  else
                    :o_form
                  end

    payment_method = case params[:payment]
                     when '15'
                       :paid
                     else
                       :not_paid
                     end

    apps = @campaign.applications.actual
      .joins(competitive_group_item: :direction)
      .joins('LEFT JOIN entrance_benefits ON entrance_benefits.application_id = entrance_applications.id')
      .send(form_method).send(payment_method).order('entrance_applications.created_at')
    # .order('(entrance_benefits.benefit_kind_id = 1) DESC, entrance_applications.number ASC')

    apps = apps.send(form_method) if opts[:form]
    apps = apps.send(payment_method) if opts[:payment]

    if opts[:date]
      apps = apps.where('DATE(entrance_applications.created_at) = ?',
                 Date.strptime(params[:date], '%d.%m.%Y'))
    end

    if opts[:faculty]
      apps = apps.from_faculty(params[:faculty])
    end

    if params[:direction].present?
      @direction = Direction.find(params[:direction])
      apps = apps.where('directions.id = ?', params[:direction])
    end

    apps
  end

end
