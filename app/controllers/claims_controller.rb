class ClaimsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :create
  load_and_authorize_resource class: EventDateClaim
  def index
    @events = Event.no_booking
  end

  def create
    @claim = EventDateClaim.new(resource_params)
    if @claim.save
      redirect_to actual_events_path, notice: 'Ваша заявка сохранена.'
    end
  end

  def update
    if @claim.update(resource_params)
      redirect_to event_claims_path(@claim.event)
    end
  end

  def destroy
    event = @claim.event
    @claim.destroy

    redirect_to event_claims_path(event)
  end

  def resource_params
    params.fetch(:event_date_claim, {}).permit(
        :fname, :status, :iname, :oname, :email, :phone, :comment, :group_id, :event_id
    )
  end

end