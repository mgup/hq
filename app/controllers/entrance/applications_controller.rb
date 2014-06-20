class Entrance::ApplicationsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :campaign, class: 'Entrance::Application'

  def index

  end

  def new

  end

  def create

  end

  def resource_params
    params.fetch(:application, {}).permit(
      :number, :registration_date
    )
  end
end