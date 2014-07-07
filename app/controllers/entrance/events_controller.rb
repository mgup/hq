class Entrance::EventsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :show
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign', except: :show
  load_and_authorize_resource through: :campaign, class: 'Entrance::Event', except: :show
  load_resource :campaign, class: 'Entrance::Campaign', only: :show
  load_resource through: :campaign, class: 'Entrance::Event', only: :show

  def index
  end

  def new
  end

  def show
    # redirect_to entrance_campaign_event_path(@campaign, 1) unless Entrance::Event.without_classroom.include? @event
  end

  def create
    if @event.save
      redirect_to entrance_campaign_events_path(@campaign),
                  notice: 'Мероприятие успешно добавлено.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @event.update(resource_params)
      redirect_to entrance_campaign_events_path(@campaign),
                  notice: 'Информация о мероприятии успешно изменена.'
    else
      render action: :edit
    end
  end

  def destroy
  end

  def resource_params
    params.fetch(:entrance_event, {}).permit(
        :campaign_id, :name, :description, :date
    )
  end
end