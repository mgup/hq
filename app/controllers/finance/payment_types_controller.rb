class Finance::PaymentTypesController < ApplicationController
  load_and_authorize_resource

  def index
    @years = @payment_types.collect{|pt| pt.year}.uniq.compact.sort!
    @payment_types = @payment_types.with_prices.my_filter(params)
    @form = params[:form]
    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def prices_filter
    authorize! :index, :payment_types

    if params
      @payment_types = Finance::PaymentType.my_filter(params)
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