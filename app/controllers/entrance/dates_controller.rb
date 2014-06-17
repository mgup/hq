class Entrance::DatesController < ApplicationController
  # load_and_authorize_resource :entrance_campaign, class: 'Entrance::Campaign'
  # load_and_authorize_resource through: :entrance_campaign
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :campaign, class: 'Entrance::Date'

  def index

  end
end