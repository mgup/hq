class Entrance::ItemsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :item,
                              through: :campaign, class: 'Entrance::CompetitiveGroupItem'

  def index ; end

  def show
    respond_to do |format|
      format.pdf
    end
  end
end