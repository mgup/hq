class Finance::PaymentTypesController < ApplicationController
  load_and_authorize_resource
  def index
    @payment_types = @payment_types
  end

  def prices_filter
    authorize! :index, :payment_types
    if params
      @payment_types = Finance::PaymentType.filter(params)
    else
      @payment_types = Finance::PaymentType.all.order(:finance_payment_type_speciality, :finance_payment_type_year)
    end
    respond_to do |format|
      format.js
    end
  end
end