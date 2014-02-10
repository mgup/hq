require 'spec_helper'

describe Group do
  it 'должен обладать валидной фабрикой' do
    build(:group).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'со специальностью' do
      should belong_to(:speciality)
    end

    it 'со студентами' do
      should have_many(:students)
    end

    it 'с дисциплинами' do
      should have_many(:disciplines).class_name('Study::Discipline')
    end

    it 'с экзаменами' do
      should have_many(:exams)
    end
  end
end