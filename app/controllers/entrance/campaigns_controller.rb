class Entrance::CampaignsController < ApplicationController
  load_and_authorize_resource class: 'Entrance::Campaign'

  def applications
    params[:form]    ||= 11
    params[:payment] ||= 14

    form_method = case params[:form]
                    when 10
                      :z_form
                    when 12
                      :oz_form
                    else
                      :o_form
                  end

    payment_method = case params[:payment]
                       when 15
                         :paid
                       else
                         :not_paid
                     end

    @applications = Entrance::Application.
      joins(competitive_group_item: :direction).
      send(form_method).send(payment_method)
  end
end