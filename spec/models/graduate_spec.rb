require 'spec_helper'
describe Graduate do
  it 'должен обладать валидной фабрикой' do
    build(:graduate).should be_valid
  end
  
  describe 'обладает связями с другими моделями:' do
    it 'с групой' do
      should belongs_to(:group)
    end
    
    it 'с выпускными предметами' do
      should has_many(:graduate_subjects)
    end
    
    it 'с аспирантами' do
      should has_many(:graduate_students)
    end
  end
end
