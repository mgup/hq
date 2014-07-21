require 'rails_helper'

describe Group do
  it 'должен обладать валидной фабрикой' do
    expect(build(:group)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'со специальностью' do
      expect belong_to(:speciality)
    end

    it 'со студентами' do
      expect have_many(:students)
    end

    it 'с дисциплинами' do
      expect have_many(:disciplines).class_name('Study::Discipline')
    end

    it 'с экзаменами' do
      expect have_many(:exams)
    end
  end
end