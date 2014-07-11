require 'rails_helper'

describe Study::DisciplineTeacher do
  it 'должен обладать валидной фабрикой' do
    expect(build(:discipline)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с дополнительными преподавателями' do
      expect belong_to(:assistant_teacher)
    end
    
    it 'с дисциплиной' do
      expect belong_to(:discipline)
    end
  end
end
