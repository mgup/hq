class Finance::PaymentTypesController < ApplicationController
  load_and_authorize_resource

  def index
    @years = @payment_types.collect{|pt| pt.year if (pt.year > 2005 && pt.year <= Study::Discipline::CURRENT_STUDY_YEAR)}.uniq.compact.sort!
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

  def print_prices
    authorize! :index, :payment_types
    @year = params[:year]
    respond_to do |format|
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="' + "Стоимость обучения#{@year ? ' на ' + @year + ' год' : ''}.xlsx" + '"'
      }
    end
  end
end