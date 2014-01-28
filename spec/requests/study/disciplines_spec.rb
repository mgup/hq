require 'spec_helper'

feature 'Работа с дисциплинами' do
  background 'Преподаватель' do

    scenario 'Просмотр списка дисциплин' do
      discipline = create(:discipline)

      visit '/study/disciplines'
      page.should have_content discipline.id
    end

  end
end