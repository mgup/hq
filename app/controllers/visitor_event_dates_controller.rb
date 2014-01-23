class VisitorEventDatesController < ApplicationController
  before_filter :find_date

  def create
    visitor = params[:visitor_event_date]
    @visitor = VisitorEventDate.create event_date_id: visitor[:event_date_id],
                                       visitor_id: visitor[:visitor_id],
                                       visitor_type: visitor[:visitor_type]
    if params[:by_admin]
      redirect_to event_path(@event)
    else
      redirect_to event_dates_path(@event)
    end
  end

  def update
    date = params[:visitor_event_date][:event_date_id]
    unless EventDate.not_full.find_all{|x| x.id == date.to_i}.empty?
      @visitor = VisitorEventDate.find(params[:visitor_event_date][:id])
      @visitor.update_attribute  :event_date_id, date
    end
    redirect_to event_path(@event)
  end

  def destroy
    @visitor = VisitorEventDate.find(params[:id])
    @visitor.destroy

    redirect_to event_path(@event)
  end

  private

  def find_date
    @event = Event.find(params[:event_id])
    @date = EventDate.find(params[:date_id])
  end

end