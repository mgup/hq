class Entrance::DocumentMovementsController < ApplicationController
  load_and_authorize_resource

  def create
    if @document_movement.from_application.original? != @document_movement.original?
      @document_movement.original_changed = true
    end

    if @document_movement.save
      @document_movement.apply_movement!

      a = @document_movement.from_application
      redirect_to entrance_campaign_entrant_applications_path(a.campaign,
                                                              a.entrant),
                  notice: 'Изменения с комплектом документов сохранены.'
    end
  end

  def show
    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.fetch(:entrance_document_movement, {}).permit(
      :moved, :original, :from_application_id, :to_application_id
    )
  end
end