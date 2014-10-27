class Entrance::CampaignsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:applications, :balls, :rating, :crimea_rating]
  load_and_authorize_resource class: 'Entrance::Campaign', except: :results
  load_resource class: 'Entrance::Campaign', only: :results

  before_action :initialize_default_filters, only: [:dashboard, :rating, :crimea_rating]

  # Заявления.
  # def dashboard
  #   fail '123'
  #   @items = Entrance::CompetitiveGroupItem.find(@applications.collect{ |app| app.competitive_group_item_id }.uniq)
  # end

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
    @orders = Office::Order.entrance.from_year_and_month(2014, 6)
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
      params[:exam] = @campaign.exams.first.id unless found
    else
      params[:exam] ||= @campaign.exams.first.id
    end

    @exam = Entrance::Exam.find(params[:exam])
    @entrants = Entrance::Entrant.from_exam(params[:exam]).
      order(:last_name, :first_name, :patronym)
  end

  def report
    @applications = @campaign.applications.
      find_all { |a| 8 == a.status_id && [11, 12].include?(a.form) && !a.payed? && %w(03 05).include?(a.direction.new_code.split('.')[1]) }
      # find_all { |a| !a.number.include?('14-ОД') && a.benefits.empty? }
      # find_all { |a| %w(03 05).include?(a.direction.new_code.split('.')[1]) }.
      # find_all { |a| [11, 12].include?(a.form) }.
      # find_all { |a| !a.payed? }

    # fail '123'

    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="' +
          "Количество поданных заявлений на #{l Time.now}.xlsx" + '"'
      end
      format.xml do
        doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.PackageData do
            # xml.Applications do
            #   @applications.each do |application|
            #     xml << application.to_fis.xpath('/Application').to_xml.to_str
            #   end
            # end
            xml.OrdersOfAdmission do
              @applications.each do |application|
                unless application.competitive_group_target_item_id.nil?
                  xml.OrderOfAdmission do
                    xml.Application do
                      xml.ApplicationNumber application.number
                      xml.RegistrationDate application.created_at.iso8601
                    end
                    xml.DirectionID application.direction.id
                    xml.EducationFormID application.competitive_group_item.form
                    # xml.FinanceSourceID (application.competitive_group_item.payed? ? 15 : ( application.competitive_group_target_item_id.nil? ? 14 : 16))
                    xml.FinanceSourceID 14
                    xml.EducationLevelID application.competitive_group_item.education_type_id
                    xml.IsBeneficiary application.benefits.any?
                    xml.Stage 1
                    # unless Date.new(2014, 7, 31) == application.order.signing_date
                    #   xml.Stage ((Date.new(2014, 8, 5) == application.order.signing_date) ? 1 : 2)
                    # end
                  end
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
      @applications = applications_from_filters
    else
      @applications = applications_from_filters(date: true)
    end

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  # def temp_print_all_checks
  #   params[:faculty] ||= 3 # 5,6,7
  #   @faculty = Department.find(params[:faculty])
  #
  #   @checks = Entrance::UseCheck.all.joins(:entrant).
  #     joins('LEFT JOIN entrance_applications AS a ON a.entrant_id = entrance_entrants.id').
  #     where('a.packed = 1').
  #     joins('LEFT JOIN competitive_group_items as i ON a.competitive_group_item_id = i.id').
  #     joins('LEFT JOIN directions AS d ON d.id = i.direction_id').
  #     where('d.department_id = ?', params[:faculty])
  #
  #     respond_to do |format|
  #       format.html
  #       format.pdf
  #     end
  # end

  def paid_enrollment
    render_report Entrance::PaidEnrollmentReport.new(@campaign)
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
    params[:direction] ||= 1887
    @direction = Direction.find(params[:direction])

    params[:form] ||= 11
    @form = EducationForm.find(params[:form])

    params[:payment] ||= 14
    @source = EducationSource.find(params[:payment])

    @applications = @campaign.applications.for_rating.rating(params[:form],
                                                             params[:payment],
                                                             params[:direction])
  end

  def applications_from_filters(opts = { form: true, payment: true, date: false })
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

    if params[:direction].present?
      @direction = Direction.find(params[:direction])
      apps = apps.where('directions.id = ?', params[:direction])
    end

    apps
  end

end