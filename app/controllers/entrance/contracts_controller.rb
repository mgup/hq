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
      group = find_group(@application.competitive_group_item, @entrant.ioo)
      if group.is_a?(Hash)
        redirect_to entrance_campaign_entrant_applications_path(
                        @campaign,
                        @entrant
                    ),
                    notice: "Не найдена группа со следующими характеристиками: код направления подготовки (специальности): #{group[:speciality]}, форма обучения: #{group[:form]}"
      else
        person = Person.create(birthday: @entrant.birthday, birthplace: @entrant.birth_place, gender: @entrant.male?, homeless: @entrant.need_hostel, passport_series: @entrant.pseries,
                               passport_number: @entrant.pnumber, passport_date: @entrant.pdate, passport_department: @entrant.pdepartment,
                               phone_mobile: @entrant.phone, residence_address: @entrant.aaddress, residence_zip: @entrant.azip,
                               fname_attributes: {ip: @entrant.last_name, rp: @entrant.last_name, dp: @entrant.last_name,
                                                  vp: @entrant.last_name, tp: @entrant.last_name, pp: @entrant.last_name},
                               iname_attributes: {ip: @entrant.first_name, rp: @entrant.first_name, dp: @entrant.first_name,
                                                  vp: @entrant.first_name, tp: @entrant.first_name, pp: @entrant.first_name},
                               oname_attributes: {ip: @entrant.patronym, rp: @entrant.patronym, dp: @entrant.patronym,
                                                  vp: @entrant.patronym, tp: @entrant.patronym, pp: @entrant.patronym},
                               students_attributes: {'0' => {student_group_group: group.id, student_group_yearin: Date.today.year, student_group_tax: Student::PAYMENT_BUDGET,
                                                     student_group_status: Student::STATUS_ENTRANT, student_group_speciality: group.speciality.id,
                                                     student_group_form: group.form}})

      @contract.number = "#{Date.today.year}-#{person.students.first.id}"
      @contract.save!

      redirect_to entrance_campaign_entrant_applications_path(
                    @campaign,
                    @entrant
                  ),
                  notice: 'Договор об образовании успешно сформирован.'
      end
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

  def find_group(competitive_group_item, ioo)
    direction = competitive_group_item.direction
    speciality = Speciality.from_direction(direction).first
    form = ioo ? 105 : competitive_group_item.matrix_form
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