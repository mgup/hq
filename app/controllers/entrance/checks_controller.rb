class Entrance::ChecksController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant, through: :campaign, class: 'Entrance::Entrant'
  load_and_authorize_resource through: :entrant, class: 'Entrance::UseCheck'

  def show
    respond_to do |format|
      format.pdf
    end
  end
end