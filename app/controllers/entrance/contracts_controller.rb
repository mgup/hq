class Entrance::ContractsController < ApplicationController
  load_and_authorize_resource :campaign,
                              class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant, through: :campaign,
                              class: 'Entrance::Campaign'
  load_and_authorize_resource :application, through: :entrant,
                              class: 'Entrance::Application'
  load_and_authorize_resource through: :application, singleton: true,
                              class: 'Entrance::Contract'

  def create
    if @contract.save!
      @contract.number = "#{Date.today.year}-#{@contract.id}"
      @contract.save!

      redirect_to entrance_campaign_entrant_applications_path(
                    @campaign,
                    @entrant
                  ),
                  notice: 'Договор об образовании успешно сформирован.'
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def destroy
    @contract.destroy

    redirect_to entrance_campaign_entrant_applications_path(
                  @campaign,
                  @entrant
                ),
                notice: 'Договор об образовании успешно удалён.'
  end

  def resource_params
    params.fetch(:entrance_contract, {}).permit(
      :sides
    )
  end
end