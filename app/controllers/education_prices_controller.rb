class EducationPricesController < ApplicationController
  skip_before_filter :authenticate_user!
  load_and_authorize_resource instance_name: :price

  def index
    params[:entrance_year] ||= Entrance::Campaign::CURRENT

    @prices = @prices.for_year(params[:entrance_year])

    @directions = []
    @prices.each do |price|
      @directions << { id:   price.direction.id,
                       code: price.direction.new_code,
                       name: price.direction.name }
    end
    @directions.uniq! { |d| d[:id] }
    @directions.sort! do |a, b|
      comp = a[:name] <=> b[:name]
      comp.zero? ? (a[:code] <=> b[:code]) : comp
    end
  end
end