require 'spec_helper'

feature 'Добавление новой дисциплины' do
  background 'Преподаватель' do

    # понять, куда это перенести
    @fd = create(:department, name: 'First Department', abbreviation: 'FD', department_role: 'faculty')
    sd = create(:department, name: 'Second Department', abbreviation: 'SD', department_role: 'faculty')
    @ffs = create(:speciality, name: 'First department first speciality', suffix: 'fdf', faculty: @fd)
    fss = create(:speciality, name: 'First department second speciality', faculty: @fd)
    @sfs = create(:speciality, name: 'Second department first speciality', suffix: 'sdf', faculty: sd)
    @ffs.groups << create(:group, speciality: @ffs)

    @user = create(:user, :lecturer)
    as_user(@user)
  end
  #scenario 'Просмотр списка дисциплин' do
  #  discipline = create(:discipline, lead_teacher: @user)
  #    visit study_disciplines_url
  #    within 'h1' do
  #      page.should have_content 'Балльно-рейтинговая система'
  #    end
  #    within 'a#new_discipline_button' do
  #      page.should have_content 'Добавить дисциплину'
  #    end
  #    within 'h4' do
  #      page.should have_content discipline.name
  #    end
  #end
  scenario 'С корректными данными', js: true, driver: :webkit do
    visit study_disciplines_path
    within 'h1' do
      page.should have_content 'Балльно-рейтинговая система'
    end
    click_link 'Добавить дисциплину'
    find_field('study_discipline[subject_year]').find('option[selected]').text.should eql "#{Study::Discipline::CURRENT_STUDY_YEAR}"
    select('FD', from: 'faculty')
    expect { select("#{@sfs.code} #{@sfs.name}", from: 'speciality') }.to raise_error
    select("#{@ffs.code} #{@ffs.name}", from: 'speciality')
    expect { find_field('study_discipline[subject_group]').find("#{@sg.name}")}.to raise_error
    #within '#study_discipline_subject_group' do
    #  page.should have_content @ffs.groups.collect{|f| f.name}.join(', ')
    #end
    #select("#{@ffs.groups.collect{|f| f.name}.join(', ')}", from: 'study_discipline[subject_group]')
    fill_in 'study_discipline[subject_name]', with: 'Example name'
    select('экзамен', from: 'study_discipline[final_exam_attributes][exam_type]')
    click_button('Сохранить дисциплину')
    #page.should have_content @ffs.groups.collect{|f| f.name}.join(', ')
    within '.has-error' do
      page.should have_content 'па ведущим преподавателем понимается'
    end
  end
end