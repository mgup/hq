class Entrance::EventEntrantsController < ApplicationController
  load_and_authorize_resource :campaign, class: Entrance::Campaign
  load_and_authorize_resource :entrant, class: Entrance::Entrant
  load_and_authorize_resource through: :entrant, class: Entrance::EventEntrant

  def create
      @event_entrant.save
      redirect_to events_entrance_campaign_entrant_path(params[:campaign_id], @entrant)
  end

  def destroy
    @event_entrant.destroy
    redirect_to events_entrance_campaign_entrant_path(params[:campaign_id], @entrant)
  end

  def resource_params
    params.fetch(:entrance_event_entrant, {}).permit(
        :entrance_entrant_id, :entrance_event_id
    )
  end

end