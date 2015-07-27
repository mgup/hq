class Entrance::EntrantsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :campaign, class: 'Entrance::Entrant'

  def index
    if current_user.is?(:selection_foreign) && @campaign.id != 52015
      @entrants = @entrants.unscoped.where(visible: true).where(campaign_id: @campaign.id).where('identity_document_type_id = 3 OR nationality_type_id != 1').order(:nationality_type_id, :last_name, :first_name)
    end
  end

  def new
    @entrant.build_edu_document
  end

  def check
    if params[:number] && params[:number] != ''
      @entrant = @entrants.from_pnumber(params[:number]).from_pseries(params[:series])

      if @entrant.any?
        if @entrant.length == 1
          redirect_to entrance_campaign_entrant_applications_path(@campaign, @entrant.first)
        end
      else
        redirect_to new_entrance_campaign_entrant_path(@campaign)
      end
    end
  end

  def create
    if @entrant.save
      @entrant.update(
        edu_document_attributes: resource_params[:edu_document_attributes]
      )

      redirect_to entrance_campaign_entrant_applications_path(@campaign, @entrant),
                  notice: 'Абитуриент успешно добавлен.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @entrant.update(resource_params)
      if @entrant.visible
      redirect_to entrance_campaign_entrant_applications_path(@campaign, @entrant),
                  notice: 'Информация об абитуриенте успешно изменена.'
      else
        @entrant.applications.each do |a|
          a.update(status_id: 6)
          a.save
        end
        redirect_to entrance_campaign_entrants_path(@campaign),
                   notice: 'Вы успешно продали смертную душу.'
      end
    else
      render action: :edit
    end

  end

  def destroy
    @entrant.destroy
    redirect_to entrance_campaign_entrants_path(@campaign)
  end

  def history
    @logs = Entrance::Log.for_entrant(@entrant)
  end

  def events
    @events = @entrant.events
    @event_entrant = Entrance::EventEntrant.new
  end

  def resource_params
    params.fetch(:entrance_entrant, {}).permit(
      :last_name, :first_name, :patronym, :gender, :snils, :information,
      :nationality_type_id, :birthday, :birth_place, :pseries, :pnumber, :pdepartment,
      :pdate, :acountry, :azip, :aregion, :aaddress, :phone, :email, :military_service,
      :foreign_language, :need_hostel, :ioo,
      :identity_document_type_id, :nationality_type_id, :visible,
      exam_results_attributes: [:id, :exam_id, :form, :score,
                                :document, :distance, :_destroy],
      achievements_attributes: [:id, :entrance_achievement_type_id, :document,
                                :date, :_destroy],
      edu_document_attributes: [:id, :document_type_id, :series, :number,
                                :date, :organization, :graduation_year,
                                :foreign_institution, :our_institution,
                                :direction_id, :qualification,
                                :_destroy ],
      papers_attributes: [:id, :name, :publication, :printed,
                              :lists, :co_authors, :_destroy ]
    )
  end
end