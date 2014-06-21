class Entrance::CampaignsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:applications]
  load_and_authorize_resource class: 'Entrance::Campaign'

  def applications
    params[:direction] ||= 1887

    @applications = applications_from_filters

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def register
    @applications = applications_from_filters

    respond_to do |format|
      format.html
      format.pdf
      format.xml do
        doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.Applications do
            @applications.each do |application|
              xml << application.to_fis.xpath('/Application').to_xml.to_str
            end
          end
        end

        render xml: doc.to_xml
      end
    end
  end

  private

  def applications_from_filters(opts = { date: false })
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
      send(form_method).send(payment_method).
      order('(entrance_benefits.benefit_kind_id = 1) DESC, entrance_applications.number ASC')

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