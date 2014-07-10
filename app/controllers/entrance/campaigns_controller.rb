class Entrance::CampaignsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:applications, :balls]
  load_and_authorize_resource class: 'Entrance::Campaign', except: :results
  load_resource class: 'Entrance::Campaign', only: :results

  def dashboard
    params[:direction] ||= 1887

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

    @direction = Direction.find(params[:direction])

    @applications = @campaign.applications.for_rating.
      where('d.id = ?', params[:direction]).
      send(form_method).send(payment_method)

    # @applications = @applications

    # @applications = @applications.page(params[:page] || 1).per(100)
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
    respond_to do |format|
      format.pdf
    end
  end

  def results
    authorize! :manage, Entrance::Exam
    params[:exam] ||= @campaign.exams.first.id
    @exam = Entrance::Exam.find(params[:exam])
    @entrants = Entrance::Entrant.from_exam(params[:exam]).order(:last_name, :first_name, :patronym)

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def balls
    params[:exam] ||= 1
    @exam = Entrance::Exam.find(params[:exam])
    @entrants = Entrance::Entrant.from_exam(params[:exam]).order(:last_name, :first_name, :patronym)
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
              unless application.entrant.pseries.blank?
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

  private

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

    apps = Entrance::Application.
      joins(competitive_group_item: :direction).
      joins('LEFT JOIN entrance_benefits ON entrance_benefits.application_id = entrance_applications.id').
      send(form_method).send(payment_method).order('entrance_applications.created_at')
      # .order('(entrance_benefits.benefit_kind_id = 1) DESC, entrance_applications.number ASC')

    if opts[:form]
      apps = apps.send(form_method)
    end

    if opts[:payment]
      apps = apps.send(payment_method)
    end

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