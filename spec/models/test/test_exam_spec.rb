require 'spec_helper'

describe Exam do
  it 'должен обладать валидной фабрикой' do
    build(:exam).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с предметом' do
      should belong_to(:subject)
    end
    it 'с группой' do
      should belong_to(:group)
    end
  it 'со студентом' do
      should belong_to(:student)
    end

     it 'с экзаменующимися' do
      should have_many(:exam_students)
    end

    it 'с оценками' do
      should have_many(:marks)
    end

  end

end