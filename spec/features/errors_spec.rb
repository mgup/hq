require 'rails_helper'

describe 'Ошибка 404' do
  it 'выводится в нашем формате' do
    visit '/404'

    expect(page.status_code).to eq(404)
    expect(page).to have_content('Страница не найдена')
  end
end

describe 'Ошибка 500' do
  it 'выводится в нашем формате' do
    visit '/500'

    expect(page.status_code).to eq(500)
    expect(page).to have_content('Кажется, что-то пошло не так')
  end
end
