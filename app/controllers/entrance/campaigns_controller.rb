class Entrance::CampaignsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:applications, :balls, :rating]
  load_and_authorize_resource class: 'Entrance::Campaign', except: :results
  load_resource class: 'Entrance::Campaign', only: :results

  before_action :initialize_default_filters, only: [:dashboard, :rating]

  # Заявления.
  def dashboard ; end

  # Пофамильные списки поступающих (рейтинги).
  def rating
    if @applications.first
      @number = @applications.first.competitive_group_item.total_number
      @number_q = @applications.first.competitive_group_item.quota_number
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
    @applications = applications_from_filters(form: false, payment: false)

    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="' +
          "Количество поданных заявлений на #{l Time.now}.xlsx" + '"'
      end
      format.xml do
        doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.Applications do
            @applications.each do |application|
              unless application.entrant.pnumber.blank?
                xml << application.to_fis.xpath('/Application').to_xml.to_str
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

  private

  # Инициализация фильтров по-умолчанию.
  def initialize_default_filters
    params[:direction] ||= 1887
    @direction = Direction.find(params[:direction])

    params[:form] ||= 11
    @form = EducationForm.find(params[:form])

    params[:payment] ||= 14
    @source = EducationSource.find(params[:payment])

    @applications = @campaign.applications.rating(params[:form],
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