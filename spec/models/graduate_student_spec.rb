require 'spec_helper'

describe GraduateStudent do
  describe 'обладает связями с другими моделями:' do
    it 'с Graduate' do
      should belong_to(:graduate)
    end
    it 'со студентом' do
      should belong_to(:student)
    end
    it 'с выпускными оценками' do
      should have_many(:graduate_marks)
    end
  end
end