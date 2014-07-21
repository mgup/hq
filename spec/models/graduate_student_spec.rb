require 'rails_helper'

describe GraduateStudent do
  describe 'обладает связями с другими моделями:' do
    it 'с выпускником' do
      expect belong_to(:graduate)
    end
    
    it 'со студентом' do
      expect belong_to(:student)
    end
    
    it 'с выпускными оценками' do
      expect have_many(:graduate_marks)
    end
  end
end
