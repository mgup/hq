require 'rails_helper'

describe Department do
  it 'должен обладать валидной фабрикой' do
    expect(build(:department)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с родительским подразделением' do
      expect belong_to(:main_department)
    end

    it 'с подчинёнными подразделениями' do
      expect have_many(:subdepartments)
    end

    it 'с назначениями на должность' do
      expect have_many(:positions)
    end

    it 'с сотрудниками' do
      expect have_many(:users).through(:positions)
    end

    it 'с учебными направлениями подготовки' do
      expect have_many(:specialities)
    end

    it 'с заявками' do
      expect have_many(:purchase_purchases)
    end
  end

  describe 'обладает ограничениями на поля' do
    it 'обязательное присутствие названия' do
      expect validate_presence_of(:name)
    end

    it 'обязательное присутствие аббревиатуры' do
      expect validate_presence_of(:abbreviation)
    end
  end
end