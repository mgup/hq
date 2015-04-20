class EventsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:actual, :calendar, :more]
  load_resource except: [:more]
  authorize_resource :event, except: [:actual, :calendar, :more]
  def index
    @events = @events.no_booking  # Пока так, чтобы ничего лишнего не смотрели
    find_events_and_dates(@events, params[:name], params[:year], params[:month], params[:day])
  end

  def actual
    params[:page] ||= 1
    authorize! :actual, :events
    @events = Event.publications
    find_events_and_dates(@events, params[:name], params[:year], params[:month], params[:day])
    @events = @events.reverse
    @events = Kaminari.paginate_array(@events).page(params[:page]).per(5)
  end

  def more
    authorize! :actual, :events
    @event = Event.find(params[:id])
    redirect_to actual_events_path if !Event.publications.include?(@event)
  end

  def calendar
    authorize! :actual, :events
    @year = params[:year].to_i
    @month = params[:month].to_i
    @href = (params[:href] == '1' ? events_path : actual_events_path)
    respond_to do |format|
      format.js
    end
  end

  def show
    @visitor = VisitorEventDate.new
  end

  def new
  end

  def create
    @event = Event.new(resource_params)
    if @event.save
      redirect_to events_path, notice: 'Событие успешно добавлено.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @event.update(resource_params)
      redirect_to events_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_path, notice: 'Событие было удалено.'
  end

  def print
    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.fetch(:event, {}).permit(:name, :description, :place, :booking, :hasclaims, :status, :event_category_id,
                 dates_attributes: [:id, :date, :time_start, :time_end, :max_visitors, :'_destroy'])
  end

  private

  def events_from_date(events, date)
    search_dates = events.collect { |e| e.dates.from_date(date) }
    search_dates.flatten.collect{ |sd| sd.event }.uniq
  end

  def find_events_and_dates(events, name = nil, year = nil, month = nil, day = nil)
    unless year || month
      @year = Date.today.year
      @month = Date.today.month
    else
      @year = year.to_i
      @month = month.to_i
    end

    @dates = []
    @events = events

    @events.each do |event|
      @dates << event.dates.collect{|d| (l d.date, format: '%d.%m.%Y')}
    end
    @dates = @dates.flatten.uniq.sort_by{|d| d,m,y=d.split('.');[y,m,d]}

    @events = @events.from_name(name) if name

    if day
      month = @month < 10 ? "0#{@month}" : @month
      @selected_day = "#{day}.#{month}.#{@year}"
      @events = events_from_date(@events, @selected_day)
    end

  end
end