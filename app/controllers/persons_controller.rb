class PersonsController < ApplicationController
  load_and_authorize_resource

  def create

  end

  def update
    if @person.update_attributes(resource_params)
      redirect_to @person.students.first
    else
      render action: 'students/show'
    end
  end

  def resource_params
    params.fetch(:person, {}).permit(:id, :birthday, :birthplace, :gender, :homeless,
          :passport_series, :passport_number, :passport_date, :passport_department,
          :email, :phone_home, :phone_mobile, :residence_address, :residence_zip,
          :registration_address, :registration_zip
    )
  end
end