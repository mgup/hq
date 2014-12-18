require 'rails_helper'

require_relative '../../../app/controllers/ajax_controller'

feature 'Добавление новой дисциплины' do
  background 'Преподаватель' do
    @group = create(:group, :with_students)
    @other_group = create(:group)

    @user = create(:user, :lecturer)
    as_user(@user)
  end

  scenario 'с корректными данными', js: true, driver: :webkit do
    visit new_study_discipline_path
    # find_field('study_discipline[subject_year]').find('option[selected]').text.should eql "#{Study::Discipline::CURRENT_STUDY_YEAR}/#{Study::Discipline::CURRENT_STUDY_YEAR + 1}"
    select(@group.speciality.faculty.abbreviation, from: 'faculty')
    # expect { select("#{@other_group.speciality.code} #{@other_group.speciality.name}", from: 'speciality') }.to raise_error
    select("#{@group.speciality.code} #{@group.speciality.name}", from: 'speciality')
    expect { select(@other_group.name, from: 'stud@sfs.y_discipline[subject_group]') }.to raise_error
    fill_in 'study_discipline[subject_name]', with: 'Example name'
    select('экзамен', from: 'study_discipline[final_exam_attributes][exam_type]')
    select(@group.name, from: 'study_discipline[subject_group]')
    click_button('Сохранить дисциплину')
    within 'h1' do
      expect(page).to have_content('Балльно-рейтинговая система')
    end
    expect(page).to have_content('Example name')
  end

  scenario 'с некорректными данными', js: true, driver: :webkit do
    visit new_study_discipline_path
    # find_field('study_discipline[subject_year]').find('option[selected]').text.should eql "#{Study::Discipline::CURRENT_STUDY_YEAR}/#{Study::Discipline::CURRENT_STUDY_YEAR + 1}"
    select(@group.speciality.faculty.abbreviation, from: 'faculty')
    select("#{@group.speciality.code} #{@group.speciality.name}", from: 'speciality')
    expect {
      select(@other_group.name, from: 'study_discipline[subject_group]')
    }.to raise_error

    select(@group.name, from: 'study_discipline[subject_group]')
    select('экзамен', from: 'study_discipline[final_exam_attributes][exam_type]')
    click_button('Сохранить дисциплину')

    expect(page).to have_css('.has-error')
  end

  scenario 'с дополнительными преподавателями', js: true, driver: :webkit do
    visit new_study_discipline_path
    click_link 'Указать дополнительного преподавателя'

    expect(page).to have_content('Доп. преподаватель')
    expect(page).to have_css('#discipline_teachers')
  end
end