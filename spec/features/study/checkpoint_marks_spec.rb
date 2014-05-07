require 'spec_helper'

feature 'Вывод списка группы для ввода оценок' do
  background 'Преподаватель' do
    # понять, куда это перенести
    @fd = create(:department, name: 'First Department', abbreviation: 'FD', department_role: 'faculty')
    ffs = create(:speciality, name: 'Empty', suffix: 'fdf', faculty: @fd)
    @fss = create(:speciality, name: 'First department second speciality', faculty: @fd)
    @group = create(:group, speciality: @fss)
    @student = create(:student, group: @group)
    @other_group = create(:group, speciality: @fss)

    @user = create(:user, :lecturer)
    as_user(@user)
    @discipline = create(:discipline, lead_teacher: @user, group: @group)
    create(:exam, :final, discipline: @discipline)
    @checkpoint =  create(:checkpoint, :control, discipline: @discipline)
    @lecture = create(:checkpoint, :lecture, discipline: @discipline)
    @practical = create(:checkpoint, :practical, discipline: @discipline)
  end

  scenario 'должен выводить правильное занятие' do
    visit study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
    page.should have_content @group.name
    page.should have_content @checkpoint.name
    page.should have_content @student.person.full_name
  end

  scenario 'если контрольная точка, должна быть форма под контрольную точку' do
    visit study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
    page.should have_css 'input[type="text"]'
  end

  scenario 'если лекция, должна быть форма под лекцию' do
    visit study_discipline_checkpoint_marks_path(@discipline, @lecture)
    page.should have_css "input[value='#{Study::Mark::MARK_LECTURE_ATTEND}']"
    page.should have_css "input[value='#{Study::Mark::MARK_LECTURE_NOT_ATTEND}']"
  end

  scenario 'если практика, должна быть форма под практику' do
    visit study_discipline_checkpoint_marks_path(@discipline, @practical)
    page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_BAD}']"
    page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_FAIR}']"
    page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_GOOD}']"
    page.should have_css "input[value='#{Study::Mark::MARK_PRACTICAL_PERFECT}']"
  end

end