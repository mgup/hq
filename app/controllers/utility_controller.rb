class UtilityController < ApplicationController
  def morpher
    render json: Morpher.inflections(params[:word])
  end
end