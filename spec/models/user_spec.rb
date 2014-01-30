require 'spec_helper'

describe User do
  it 'должен обладать валидной фабрикой' do
    build(:user).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с назначениями на должность' do
      should have_many(:positions)
    end

    it 'с ролями' do
      should have_many(:roles).through(:positions)
    end

    it 'с подразделениями' do
      should have_many(:departments).through(:positions)
    end

    it 'с таблицей для связи преподавателя и дисциплины' do
      should have_many(:discipline_teachers)
    end

    it 'с дисциплинами' do
      should have_many(:disciplines).through(:discipline_teachers)
    end
  end
end
