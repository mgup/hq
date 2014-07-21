require 'rails_helper'

describe Study::ExamStudent do
  it 'должен обладать валидной фабрикой' do
    expect(build(:exam_student)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с  экзаменом' do
      expect belong_to(:exam)
    end
    
    it 'со студентом' do
      expect belong_to(:student)
    end
    
    it 'с человеком' do
      expect belong_to(:person)
    end
  end
end
