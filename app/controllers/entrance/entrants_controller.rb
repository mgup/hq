class Entrance::EntrantsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :campaign, class: 'Entrance::Entrant'

  def index

  end

  def new

  end

  def create
    if @entrant.save
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
      redirect_to entrance_campaign_entrant_applications_path(@campaign, @entrant),
                  notice: 'Информация об абитуриенте успешно изменена.'
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

  def resource_params
    params.fetch(:entrance_entrant, {}).permit(
      :last_name, :first_name, :patronym, :gender, :snils, :information,
      :citizenship, :birthday, :birth_place, :pseries, :pnumber, :pdepartment,
      :pdate, :acountry, :azip, :aregion, :aaddress, :phone, :military_service,
      :foreign_institution, :institution, :graduation_year, :certificate_number,
      :certificate_date, :foreign_language, :need_hostel,
      :identity_document_type_id, :nationality_type_id,
      exam_results_attributes: [:id, :exam_id, :form, :score,
                                :document, :'_destroy']
    )
  end
end