require 'spec_helper'

describe ExamStudent do
  it 'должен обладать валидной фабрикой' do
    build(:exam).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      should belong_to(:exam)
    end
    it 'со студентом' do
      should belong_to(:student)
    end
  end

end