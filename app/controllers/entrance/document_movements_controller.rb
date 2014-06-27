class Entrance::DocumentMovementsController < ApplicationController
  load_and_authorize_resource

  def create
    raise '123'

    if @document_movement.save
      @document_movement.apply_movement!

      app = @document_movement.from_application


      # Производим необходимые изменения.
      if @document_movement.moved?
        app.packed = false
        app.save!

        @document_movement.to_application.packed = false
        @document_movement.to_application.save!
      end

      redirect_to entrance_campaign_entrant_applications_path(app.campaign, app.entrant),
                  notice: 'Изменения с комплектом документов сохранены.'
    end
  end

  def resource_params
    params.fetch(:entrance_document_movement, {}).permit(
      :moved, :original, :from_application_id, :to_application_id
    )
  end
end