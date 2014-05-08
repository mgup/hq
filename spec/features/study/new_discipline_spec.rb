require 'spec_helper'

require_relative '../../../app/controllers/ajax_controller'

feature 'Добавление новой дисциплины' do
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
  end

  scenario 'с корректными данными', js: true, driver: :webkit do
    visit new_study_discipline_path
    find_field('study_discipline[subject_year]').find('option[selected]').text.should eql "#{Study::Discipline::CURRENT_STUDY_YEAR}/#{Study::Discipline::CURRENT_STUDY_YEAR + 1}"
    select('FD', from: 'faculty')
    expect { select("#{@sfs.code} #{@sfs.name}", from: 'speciality') }.to raise_error
    select("#{@fss.code} #{@fss.name}", from: 'speciality')
    expect { select(@other_group.name, from: 'study_discipline[subject_group]') }.to raise_error
    select(@group.name, from: 'study_discipline[subject_group]')
    fill_in 'study_discipline[subject_name]', with: 'Example name'
    select('экзамен', from: 'study_discipline[final_exam_attributes][exam_type]')
    click_button('Сохранить дисциплину')
    within 'h1' do
      page.should have_content 'Балльно-рейтинговая система'
    end
    page.should have_content 'Example name'
  end

  scenario 'с некорректными данными', js: true, driver: :webkit do
    visit new_study_discipline_path
    find_field('study_discipline[subject_year]').find('option[selected]').text.should eql "#{Study::Discipline::CURRENT_STUDY_YEAR}/#{Study::Discipline::CURRENT_STUDY_YEAR + 1}"
    select('FD', from: 'faculty')
    expect {
      select("#{@sfs.code} #{@sfs.name}", from: 'speciality')
    }.to raise_error

    select("#{@fss.code} #{@fss.name}", from: 'speciality')
    expect {
      select(@other_group.name, from: 'study_discipline[subject_group]')
    }.to raise_error

    select(@group.name, from: 'study_discipline[subject_group]')
    select('экзамен', from: 'study_discipline[final_exam_attributes][exam_type]')
    click_button('Сохранить дисциплину')

    page.should have_css '.has-error'
  end

  scenario 'с дополнительными преподавателями', js: true, driver: :webkit do
    visit new_study_discipline_path
    click_link 'Указать дополнительного преподавателя'
    page.should have_content 'Доп. преподаватель'
    page.should have_css '#discipline_teachers'
  end

end