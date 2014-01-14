class DatesController < ApplicationController
  load_and_authorize_resource class: EventDate

  before_filter :find_event

  def index
    @visitor = VisitorEventDate.new
    @current = current_user || current_student
  end

  def print
    respond_to do |format|
      format.pdf
    end
  end

  def update
    if EventDate.valid_max_visitors?(@date.visitors.count, params[:event_date][:max_visitors])
      @date.update_attribute  :max_visitors, params[:event_date][:max_visitors]
      redirect_to event_path(@event), notice: 'Дата успешно сохранена'
    else 
      redirect_to event_path(@event), notice: 'Число свободных мест не может быть меньше пользователей, которые уже забронировали дату' 
    end
  end

  private

  def find_event
    @event = Event.find(params[:event_id])
  end

end