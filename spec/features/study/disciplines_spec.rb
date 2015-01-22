require 'rails_helper'

feature 'Просмотр дисциплин' do
  background 'Преподаватель' do
    @discipline = create(:exam, :final, discipline: create(:discipline, group: create(:group, :with_students))).discipline
    as_user(@discipline.lead_teacher)
  end

  scenario 'Просмотр списка дисциплин' do
    visit study_disciplines_path
    expect(page).to have_content(@discipline.name)
  end

  scenario 'Добавление новой дисциплины' do
    visit study_disciplines_path
    click_link 'Добавить дисциплину'
    expect(page).to have_selector('#new_study_discipline')
  end

  scenario 'Внесение данных для дисциплины без контрольных точек' do
    visit study_disciplines_path

    expect(page).to have_selector('.add_marks .glyphicon-calendar')

    click_link 'Внести данные'

    expect(page).to have_content(@discipline.name)
  end

  scenario 'Внесение данных для дисциплины с контрольными точками' do
    control = create(:checkpoint, :control, discipline: @discipline)
    visit study_disciplines_path
    click_link 'Внести данные'

    expect(page).to have_content(@discipline.name)
    expect(page).to have_content(control.name)
  end

  scenario 'Редактирование дисциплины' do
    visit study_disciplines_path
    click_link 'Редактировать'

    expect(page).to have_css("#edit_study_discipline_#{@discipline.id}")
  end

  scenario 'Удаление дисциплины без контрольных точек', js: true, driver: :webkit do
    visit study_disciplines_path
    click_link 'Удалить'
    page.driver.browser.accept_js_confirms

    expect(page).not_to have_content(@discipline.name)
  end

  scenario 'Нельзя удалить дисциплину с контрольными точками' do
    create(:checkpoint, :control, discipline: @discipline)
    visit study_disciplines_path

    expect(page).not_to have_selector('.delete_empty_discipline')
  end
end