require 'spec_helper'

describe Study::ExamStudent do
  it 'должен обладать валидной фабрикой' do
    build(:exam_student).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с  экзаменом' do
      should belong_to(:exam)
    end
    it 'со студентом' do
      should belong_to(:student)
    end
    it 'с человеком' do
      should belong_to(:person)
    end

  end

end