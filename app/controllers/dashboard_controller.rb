class DashboardController < ApplicationController
  def index
    redirect_to selection_contract_path if current_user.is?(:zamestitel_otvetstvennogo_sekretarja)

    redirect_to selection_contract_path if current_user.is?(:chief_accountant)
  end
end
