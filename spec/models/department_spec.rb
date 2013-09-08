require 'spec_helper'

describe Department do
  it 'должен обладать валидной фабрикой' do
    build(:department).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с родительским подразделением' do
      should belong_to(:main_department)
    end

    it 'с подчинёнными подразделениями' do
      should have_many(:subdepartments)
    end

    it 'с назначениями на должность' do
      should have_many(:positions)
    end

    it 'с сотрудниками' do
      should have_many(:users).through(:positions)
    end

    it 'с учебными направлениями подготовки' do
      should have_many(:specialities)
    end
  end

  describe 'обладает ограничениями на поля' do
    it 'обязательное присутствие названия' do
      should validate_presence_of(:name)
    end

    it 'обязательное присутствие аббревиатуры' do
      should validate_presence_of(:abbreviation)
    end
  end
end