class Entrance::ContractsController < ApplicationController
  load_and_authorize_resource :campaign,
                              class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant, through: :campaign,
                              class: 'Entrance::Campaign', except: :statistics
  load_and_authorize_resource :application, through: :entrant,
                              class: 'Entrance::Application', except: :statistics
  load_and_authorize_resource through: :application, singleton: true,
                              class: 'Entrance::Contract', except: :statistics
  load_and_authorize_resource through: :campaign, class: 'Entrance::Contract', only: :statistics

  def create
    if @contract.save!
      group = find_group(@application.competitive_group_item, @application)
      if group.is_a?(Hash)
        @contract.destroy
        @notice = "Не найдена группа со следующими характеристиками: код направления подготовки (специальности): #{group[:speciality]}, форма обучения: #{group[:form]}"
      else
        army = case @entrant.military_service
               when 'not'
                 Person::ARMY_NOT_RESERVIST
               when 'conscript'
                 Person::ARMY_INDUCTEE
               when 'reservist'
                 Person::ARMY_RESERVIST
               when 'free_of_service'
                 Person::ARMY_NOT_RESERVIST
               when 'too_young'
                 Person::ARMY_NOT_RESERVIST
               end

        person = Person.create!(
          birthday: @entrant.birthday,
          birthplace: @entrant.birth_place,
          gender: @entrant.male?,
          homeless: @entrant.need_hostel,
          passport_series: @entrant.pseries,
          passport_number: @entrant.pnumber,
          passport_date: @entrant.pdate,
          passport_department: @entrant.pdepartment,
          phone_mobile: @entrant.phone,
          residence_address: @entrant.aaddress,
          residence_zip: @entrant.azip,
          student_foreign: (3 == @entrant.nationality_type_id.to_i),
          army: army,
          last_name_hint: @entrant.last_name,
          first_name_hint: @entrant.first_name,
          patronym_hint: @entrant.patronym,
          student_oldid: 0,
          student_oldperson: 0,
          fname_attributes: {
            ip: @entrant.last_name,
            rp: @entrant.last_name,
            dp: @entrant.last_name,
            vp: @entrant.last_name,
            tp: @entrant.last_name,
            pp: @entrant.last_name
          },
          iname_attributes: {
            ip: @entrant.first_name,
            rp: @entrant.first_name,
            dp: @entrant.first_name,
            vp: @entrant.first_name,
            tp: @entrant.first_name,
            pp: @entrant.first_name
          },
          oname_attributes: {
            ip: @entrant.patronym,
            rp: @entrant.patronym,
            dp: @entrant.patronym,
            vp: @entrant.patronym,
            tp: @entrant.patronym,
            pp: @entrant.patronym
          },
          students_attributes: {
            '0' => {
              student_group_group: group.id,
              student_group_yearin: Date.today.year,
              student_group_tax: Student::PAYMENT_OFF_BUDGET,
              student_group_status: Student::STATUS_ENTRANT,
              student_group_speciality: group.speciality.id,
              student_group_form: group.form,
              student_group_oldgroup: 0,
              student_group_oldstudent: 0,
              entrant_id: @entrant.id
            }
          }
        )

      @contract.number = "#{Date.today.year}-#{person.students.first.id}"
      @contract.save!

      # redirect_to entrance_campaign_entrant_applications_path(
      #               @campaign,
      #               @entrant
      #             ),
      #             notice: 'Договор об образовании успешно сформирован.'
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html do
        render layout: 'modal'
      end
      format.pdf
    end
  end

  def statistics

  end

  def destroy
    number = @contract.number
    number.slice! "#{Date.today.year}-"
    student = Student.find(number.to_i)

    if student
      student.person.destroy
      student.destroy
    end

    @contract.destroy

    respond_to do |format|
      format.js
    end

    # redirect_to entrance_campaign_entrant_applications_path(
    #               @campaign,
    #               @entrant
    #             ),
    #             notice: 'Договор об образовании успешно удалён.'
  end

  def resource_params
    params.fetch(:entrance_contract, {}).permit(
      :sides, :delegate_last_name, :delegate_first_name, :delegate_patronym, :delegate_address,
      :delegate_phone, :delegate_pseries, :delegate_pnumber, :delegate_pdepartment, :delegate_pdate,
      :delegate_organization, :delegate_position, :delegate_mobile, :delegate_fax, :delegate_inn, :delegate_kpp,
      :delegate_ls, :delegate_bik
    )
  end

  def find_group(competitive_group_item, application)
    direction = competitive_group_item.direction

    specialities = Speciality.from_direction(direction)
    if specialities.any?
      speciality = specialities.first
    else
      speciality = Speciality.where(speciality_code: direction.new_code).first
    end

    form = application.matrix_form_number
    group = Group.filter(speciality: [speciality.id], form: [form], course: [1]).first if speciality
    if group
      return group
    else
      return { speciality: direction.code+'.'+direction.qualification_code.to_s, form: (case form
                                                                                         when 101
                                                                                           'очная'
                                                                                         when 102
                                                                                           'очно-заочная'
                                                                                         when 103
                                                                                           'заочная'
                                                                                         when 105
                                                                                           'дистанционная'
                                                                                        end) }
    end
  end
end