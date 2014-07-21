require 'rails_helper'

describe Graduate do
  describe 'обладает связями с другими моделями:' do
    it 'с групой' do
      expect belong_to(:group)
    end
      
    it 'с выпускными предметами' do
      expect have_many(:graduate_subjects)
    end
    
    it 'с аспирантами' do
      expect have_many(:graduate_students)
    end
  end
end

