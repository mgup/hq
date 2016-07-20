class Entrance::RatingController < ApplicationController
  load_resource :campaign, class: 'Entrance::Campaign', id_key: :id
  load_and_authorize_resource :applications, through: :campaign, class: 'Entrance::Applications'

  def index
    load_directions
  end

  private

  def load_directions
    @directions = Entrance::Campaign.where(start_year: Entrance::Campaign::CURRENT_YEAR).
      map(&:competitive_groups).sum.map(&:items).sum.map(&:direction).uniq.sort_by do |d|
      [d.bachelor? || d.specialist? ? 1 : 2, d.master? ? 1 : 2, d.name]
    end
  end
end
