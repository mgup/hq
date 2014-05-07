require 'spec_helper'

feature 'Редактирование дисциплины' do
  background 'Преподаватель' do
    # понять, куда это перенести
    @fd = create(:department, name: 'First Department', abbreviation: 'FD', department_role: 'faculty')
    sd = create(:department, name: 'Second Department', abbreviation: 'SD', department_role: 'faculty')
    ffs = create(:speciality, name: 'Empty', suffix: 'fdf', faculty: @fd)
    @fss = create(:speciality, name: 'First department second speciality', faculty: @fd)
    @sfs = create(:speciality, name: 'Second department first speciality', suffix: 'sdf', faculty: sd)
    @group = create(:group, speciality: @fss)
    @other_group = create(:group, speciality: @sfs)

    @user = create(:user, :lecturer)
    as_user(@user)
    @discipline = create(:discipline, lead_teacher: @user, group: @group)
    create(:exam, :final, discipline: @discipline)
  end

  scenario 'поля должны соответствовать редактируемой дисциплине', js: true, driver: :webkit do
    visit edit_study_discipline_path(@discipline)
    semester = case @discipline.semester
                 when 1
                   'осенний'
                 when 2
                   'весенний'
               end
    find_field('study_discipline[subject_year]').find('option[selected]').text.should eql "#{@discipline.year}/#{@discipline.year+1}"
    find_field('study_discipline[subject_semester]').find('option[selected]').text.should eql "#{semester}"
    find_field('faculty').find('option[selected]').text.should eql "#{@discipline.group.speciality.faculty.abbreviation}"
    find_field('speciality').find('option[selected]').text.should eql "#{@discipline.group.speciality.code} #{@discipline.group.speciality.name}"
    find_field('study_discipline[subject_group]').find('option[selected]').text.should eql "#{@discipline.group.name}"
    find_field('study_discipline[subject_name]').value.should eql "#{@discipline.name}"
    find_field('study_discipline[final_exam_attributes][exam_type]').find('option[selected]').text.should eql "#{@discipline.final_exam.name}"
    find_field('study_discipline[final_exam_attributes][exam_weight]').value.should eql "#{@discipline.final_exam.weight}"
    find_field('study_discipline[subject_teacher]').find('option[selected]').text.should eql "#{@discipline.lead_teacher.full_name}"
  end

  scenario 'должен показывать дополнительных преподавателей' do
    other_teacher = create(:user)
    create(:position, user: other_teacher, role: FactoryGirl.create(:role, :lecturer), department: @user.departments.academic.first)
    @discipline.assistant_teachers << other_teacher
    visit edit_study_discipline_path(@discipline)
    find('#discipline_teachers').find('select').find('option[selected]').value.should eql "#{other_teacher.id}"
  end

  scenario 'должен быть ведущим преподавателем' do
    visit edit_study_discipline_path(@discipline)
    find_field('study_discipline[subject_teacher]').find('option[selected]').text.should eql "#{@user.full_name}"
  end

  scenario 'должен быть дополнительным преподавателем' do
    discipline = create(:discipline, lead_teacher: create(:user, :lecturer))
    discipline.assistant_teachers << @user
    visit edit_study_discipline_path(discipline)
    find('#discipline_teachers').find('select').find('option[selected]').text.should eql "#{@user.full_name}"
  end

  scenario 'должен удалять дополнительных преподавателей', js: true, driver: :webkit do
     other_teacher = create(:user)
     create(:position, user: other_teacher, role: FactoryGirl.create(:role, :lecturer), department: @user.departments.academic.first)
     @discipline.assistant_teachers << other_teacher
     visit edit_study_discipline_path(@discipline)
     within '#discipline_teachers' do
       click_link 'Удалить'
     end
     click_button('Сохранить дисциплину')
  end

  #scenario 'при удалении себя как дополнительного преподавателя дисциплина должна исчезать из списка' do
  #   discipline = create(:discipline, lead_teacher: create(:user, :lecturer))
  #   discipline.assistant_teachers << @user
  #   visit edit_study_discipline_path(discipline)
  #   click_link 'Удалить'
  #   click_button('Сохранить дисциплину')
  #   page.should_not have_content discipline.name
  #end

  scenario 'должен редактировать дисциплину при корректных данных' do
    create(:checkpoint, :control, discipline: @discipline)
    visit edit_study_discipline_path(@discipline)
    fill_in 'study_discipline[subject_name]', with: 'Example name'
    click_button('Сохранить дисциплину')
    within 'h1' do
      page.should have_content 'Example name'
    end
  end

  scenario 'если данные некорректны, должен возвращаться к редактированию' do
    visit edit_study_discipline_path(@discipline)
    fill_in 'study_discipline[final_exam_attributes][exam_weight]', with: '1000'
    click_button('Сохранить дисциплину')
    page.should have_css '.has-error'
    page.should have_css "#edit_study_discipline_#{@discipline.id}"
  end

  scenario 'если у дисциплины есть курсовая работа или проект, они должны быть отмечены' do
     create(:exam, :work, discipline: @discipline)
    visit edit_study_discipline_path(@discipline)
    page.should have_checked_field 'has_semester_work'
  end

  scenario 'если у дисциплины нет курсовой работы или проекта, они не должны быть отмечены' do
    visit edit_study_discipline_path(@discipline)
    page.should_not have_checked_field 'has_semester_work'
    page.should_not have_checked_field 'has_semester_project'
  end

  scenario 'при редактировании можно добавить курсовую работу или проект' do
    visit edit_study_discipline_path(@discipline)
    find("input[type='checkbox']#has_semester_work").set(true)
    expect{
      click_button('Сохранить дисциплину')
    }.to change { @discipline.exams.count }.by(1)
  end

  scenario 'при редактировании можно убрать курсовую работу или проект' do
    create(:exam, :work, discipline: @discipline)
    visit edit_study_discipline_path(@discipline)
    find("input[type='checkbox']#has_semester_work").set(false)
    expect{
      click_button('Сохранить дисциплину')
    }.to change { @discipline.exams.count }.by(-1)
  end

end