class PersonsController < ApplicationController
  load_and_authorize_resource

  def new
    @person.build_fname
    @person.build_iname
    @person.build_oname
  end
  
  def create
    @person = Person.create(resource_params)
    if @person.save
      redirect_to new_student_path(person: @person.id)
    else
      render action: :new
    end
  end

  def update
    if @person.update_attributes(resource_params)
      redirect_to @person.students.first
    else
      render action: 'students/show'
    end
  end

  def create_employer
    @person.update_attribute :employer, params[:employer]
    @person.save!
    respond_to do |format|
      format.js
    end
  end

  def resource_params
    params.fetch(:person, {}).permit(:id, :birthday, :birthplace, :gender, :homeless,
          :passport_series, :passport_number, :passport_date, :passport_department, :employer,
          :email, :phone_home, :phone_mobile, :residence_address, :residence_zip,
          :registration_address, :registration_zip, :student_mother_name, :student_mother_phone, :student_father_name, :student_father_phone,
          fname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
          iname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
          oname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp]
    )
  end
end