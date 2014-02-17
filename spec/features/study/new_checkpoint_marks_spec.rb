require 'spec_helper'

feature 'Ввод оценок за занятия' do
  background 'Преподаватель' do
    # понять, куда это перенести
    @fd = create(:department, name: 'First Department', abbreviation: 'FD', department_role: 'faculty')
    ffs = create(:speciality, name: 'Empty', suffix: 'fdf', faculty: @fd)
    @fss = create(:speciality, name: 'First department second speciality', faculty: @fd)
    @group = create(:group, speciality: @fss)
    @student = create(:student, group: @group)

    @user = create(:user, :lecturer)
    as_user(@user)
    @discipline = create(:discipline, lead_teacher: @user, group: @group)
    create(:exam, :final, discipline: @discipline)
    @checkpoint =  create(:checkpoint, :checkpoint_control, discipline: @discipline)
    @lecture = create(:checkpoint, :lecture, discipline: @discipline)
    @practical = create(:checkpoint, :practical, discipline: @discipline)
  end

  scenario 'если контрольная точка, должен ввести число в поле и сохранить оценку' do
    visit study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
    fill_in 'study_checkpoint[marks_attributes][0][mark]', with: '30'
    expect{
      click_button 'Внести результаты'
    }.to change { @student.marks.count }.by(1)
  end

  scenario 'если контрольная точка и введены некорректные данные, не должен сохранить оценку', js: true, driver: :webkit do
    visit study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
    fill_in 'study_checkpoint[marks_attributes][0][mark]', with: '100'
    expect{
      click_button 'Внести результаты'
    }.not_to change { @student.marks.count }.by(1)
    page.should have_content 'Проверьте правильность введенных баллов'
  end

  #scenario 'если лекция, должна быть форма под лекцию' do
  #  visit study_discipline_checkpoint_marks_path(@discipline, @lecture)
  #  page.should have_css "input[value='#{Study::Mark::MARK_LECTURE_ATTEND}']"
  #  page.should have_css "input[value='#{Study::Mark::MARK_LECTURE_NOT_ATTEND}']"
  #end
  #
  #scenario 'если практика, должна быть форма под практику' do
  #  visit study_discipline_checkpoint_marks_path(@discipline, @lecture)
  #  page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_BAD}']"
  #  page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_FAIR}']"
  #  page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_GOOD}']"
  #  page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_PERFECT}']"
  #end

end