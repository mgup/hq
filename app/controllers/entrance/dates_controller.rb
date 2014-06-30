class Entrance::DatesController < ApplicationController
  # load_and_authorize_resource :entrance_campaign, class: 'Entrance::Campaign'
  # load_and_authorize_resource through: :entrance_campaign
  skip_before_filter :authenticate_user!, only: :index
  load_resource :campaign, class: 'Entrance::Campaign'
  load_resource through: :campaign, class: 'Entrance::Date'

  def index

  end
end