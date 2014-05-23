require 'spec_helper'
describe Graduate do
  
  describe 'обладает связями с другими моделями:' do

    it 'с групой' do
      should belong_to(:group)
    end

    it 'с выпускными предметами' do
      should have_many(:graduate_subjects)
    end
    
    it 'с аспирантами' do
      should have_many(:graduate_students)
    end
  end
end
