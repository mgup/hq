class ClaimsController < ApplicationController
  load_and_authorize_resource class: EventDateClaim
  def index
    @events = Event.no_booking
  end

  def create
    @claim = EventDateClaim.new(resource_params)
    if @claim.save
      redirect_to actual_events_path
    end
  end

  def resource_params
    params.fetch(:event_date_claim, {}).permit(
        :fname, :iname, :oname, :email, :phone, :group_id, :event_id
    )
  end

end