require 'spec_helper'

feature 'Ввод оценок за занятия' do
  background 'Преподаватель' do
    # понять, куда это перенести
    @discipline = create(:exam, :final).discipline
    @group = @discipline.group
    @student = create(:student, group: @group)

    as_user(@discipline.lead_teacher)

    @checkpoint =  create(:checkpoint, :control, discipline: @discipline)
    @lecture = create(:checkpoint, :lecture, discipline: @discipline)
    @practical = create(:checkpoint, :practical, discipline: @discipline)
  end

  scenario 'если лекция, должна отображаться правильная оценка' do
    mark = create(:mark, :lecture, student: @student, checkpoint: @lecture)
    visit study_discipline_checkpoint_marks_path(@discipline, @lecture)
    within "span.label-#{mark.result[:color]}" do
      page.should have_content mark.result[:mark]
    end
  end

  scenario 'если практика, должна отображаться правильная оценка' do
    mark = create(:mark, :practical, student: @student, checkpoint: @practical)
    visit study_discipline_checkpoint_marks_path(@discipline, @practical)
    within "span.label-#{mark.result[:color]}" do
      page.should have_content mark.result[:mark]
    end
  end

  scenario 'если контрольная точка, должна отображаться правильная оценка' do
    mark = create(:mark, :checkpoint, student: @student, checkpoint: @checkpoint)
    visit study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
    within 'span.label' do
      page.should have_content "#{mark.mark} из #{@checkpoint.max}"
    end
  end

  scenario 'форма должна быть спрятана', js: true, driver: :webkit do
    create(:mark, :lecture, student: @student, checkpoint: @lecture)
    visit study_discipline_checkpoint_marks_path(@discipline, @lecture)
    page.should have_css('.editMarkField', visible: false)
  end

  scenario 'при нажатии на "Редактировать" должна появляться форма', js: true, driver: :webkit do
    create(:mark, :lecture, student: @student, checkpoint: @lecture)
    visit study_discipline_checkpoint_marks_path(@discipline, @lecture)
    click_button 'Редактировать'
    within '.editMarkButton' do
      page.should have_content 'Сохранить'
    end
    page.should have_css('.editMarkField', visible: true)
  end

  scenario 'при редактировании должна сохраняться новая оценка с полем retake', js: true, driver: :webkit do
    mark = create(:mark, :checkpoint, student: @student, checkpoint: @checkpoint)
    visit study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
    click_button 'Редактировать'
    fill_in 'study_checkpoint[marks_attributes][0][mark]', with: 60
    click_button 'Сохранить'
    within 'span.label' do
      page.should have_content "60 из #{@checkpoint.max}"
    end
  end

  scenario 'при вводе некорректных данных должно появляться предупреждение', js: true, driver: :webkit do
    mark = create(:mark, :checkpoint, student: @student, checkpoint: @checkpoint)
    visit study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
    click_button 'Редактировать'
    fill_in 'study_checkpoint[marks_attributes][0][mark]', with: 160
    click_button 'Сохранить'
    page.should have_content 'Вы пытались ввести некорректное значение'
  end

end