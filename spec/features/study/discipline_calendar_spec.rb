require 'rails_helper'

feature 'Вывод списка группы для ввода оценок' do
  background 'Преподаватель' do
    @discipline = create(:exam, :final, discipline: create(:discipline, group: create(:group, :with_students))).discipline
    as_user(@discipline.lead_teacher)

    if 1 == Study::Discipline::CURRENT_STUDY_TERM
      @date = "13.09.#{Study::Discipline::CURRENT_STUDY_YEAR}"
    else
      @date = "13.02.#{Study::Discipline::CURRENT_STUDY_YEAR + 1}"
    end
  end

  scenario 'если нет контрольных точек, должен перенаправлять на календарь' do
    visit study_disciplines_path
    click_link 'Внести данные'

    expect(page).to have_content(@discipline.group.name)
    expect(page).to have_content(@discipline.name)
    expect(page).to have_css('.semester-calendar')
  end

  scenario 'если осенний семестр, должен выводить календарь с сентября по декабрь' do
    autumn_discipline = create(:exam, :final, discipline: create(:discipline, semester: 1, lead_teacher: @discipline.lead_teacher)).discipline
    visit study_discipline_checkpoints_path(autumn_discipline)

    expect(page).to have_content('сент.')
    expect(page).to have_content('дек.')
  end

  scenario 'если весенний семестр, должен выводить календарь с января по июнь' do
    spring_discipline = create(:exam, :final, discipline: create(:discipline, semester: 2, lead_teacher: @discipline.lead_teacher)).discipline
    visit study_discipline_checkpoints_path(spring_discipline)

    expect(page).to have_content('янв.')
    expect(page).to have_content('июня')
  end

  scenario 'по клику на календарь должны появляться спрятанные формы (лекции)', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)
    within '.lectures' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    expect(page).to have_css('.lecture_fields')

    within '.lecture_fields' do
      expect(page).to have_css(%Q(input[value="#{@date}"]), visible: false)
      expect(page).to have_css('input[value="false"]', visible: false)
    end
  end

  scenario 'по клику выделенной даты, занятие должно помечаться на удаление (лекции)', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)

    within '.lectures' do
      find(%Q(td[data-date="#{@date}"])).click
      find(%Q(td[data-date="#{@date}"])).click
    end

    within('.lecture_fields', visible: false) do
      expect(page).to have_css(%Q(input[value="#{@date}"]), visible: false)
      expect(page).to have_css('input[value="1"]', visible: false)
    end
  end

  scenario 'занятия должны сохраняться (лекции)', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)

    within '.lectures' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    within '.checkpoints' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    within '.checkpoint_fields' do
      fill_in 'Название', with: 'Example name'
      fill_in 'Описание', with: 'Example descripltion'
      fill_in 'Максимальный балл', with: '80'
      fill_in 'Зачётный минимум', with: '44'
    end

    click_button 'Сохранить информацию о контрольных точках'

    within 'table' do
      expect(page).to have_content('Лекция')
      expect(page).to have_content('Example name')
    end
  end

  scenario 'занятия должны сохраняться (лекции)', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)

    within '.seminars' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    within '.checkpoints' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    within '.checkpoint_fields' do
      fill_in 'Название', with: 'Example name'
      fill_in 'Описание', with: 'Example descripltion'
      fill_in 'Максимальный балл', with: '80'
      fill_in 'Зачётный минимум', with: '44'
    end

    click_button 'Сохранить информацию о контрольных точках'

    within 'table' do
      expect(page).to have_content('Практическое (лабораторное) занятие')
      expect(page).to have_content('Example name')
      # expect(page).to have_content('Внести результаты')
    end
  end

  scenario 'по клику на календарь должны появляться формы (контрольные точки)', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)

    within '.checkpoints' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    expect(page).to have_css('.checkpoint_fields')

    within '.checkpoint_fields' do
      expect(page).to have_css(%Q(input[data-date="#{@date}"]))
      expect(page).to have_content('Дата')
      expect(page).to have_content('Название')
      expect(page).to have_content('Описание')
      expect(page).to have_content('Максимальный балл')
      expect(page).to have_content('Зачётный минимум')
    end
  end

  scenario 'при верном заполнении контрольных точек должен перенаправлять на страницу с занятиями', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)

    within '.checkpoints' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    within '.checkpoint_fields' do
      fill_in 'Название', with: 'Example name'
      fill_in 'Описание', with: 'Example descripltion'
      fill_in 'Максимальный балл', with: '80'
      fill_in 'Зачётный минимум', with: '44'
    end

    click_button 'Сохранить информацию о контрольных точках'

    within 'h1' do
      expect(page).to have_content(@discipline.name)
    end

    within 'table' do
      expect(page).to have_content('Example name')
      expect(page).to have_content(@date)
      # expect(page).to have_content('Внести результаты')
    end
  end

  scenario 'если не введено название, не должен сохранять', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)

    within '.checkpoints' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    within '.checkpoint_fields' do
      fill_in 'Описание', with: 'Example descripltion'
      fill_in 'Максимальный балл', with: '80'
      fill_in 'Зачётный минимум', with: '44'
    end

    click_button 'Сохранить информацию о контрольных точках'

    expect(page).to have_css('.has-error')
  end

  scenario 'при неверном заполнении минимума и максимума не должен сохранять', js: true, driver: :webkit do
    visit study_discipline_checkpoints_path(@discipline)

    within '.checkpoints' do
      find(%Q(td[data-date="#{@date}"])).click
    end

    within '.checkpoint_fields' do
      fill_in 'Название', with: 'Example name'
      fill_in 'Описание', with: 'Example descripltion'
      fill_in 'Максимальный балл', with: '90'
      fill_in 'Зачётный минимум', with: '94'
    end

    click_button 'Сохранить информацию о контрольных точках'

    expect(page).to have_content(
      'Сумма максимальных баллов должна равняться 80. У вас — 90.'
    )
    expect(page).to have_content(
      'Сумма минимальных зачётных баллов должна равняться 44. У вас — 94.'
    )
    expect(page).to have_content(
      'Минимальный зачётный балл должен быть меньше, чем максимальный балл.'
    )
  end
end

