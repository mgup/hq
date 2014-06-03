require 'spec_helper'

describe Study::Repeat do
  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      should belong_to(:exam)
    end

    it 'со студентом' do
      should have_belong_to_many(:students)
    end
    
    it 'с протестующим студентом' do
      should belong_to(:deprecated_student)
    end
  end
end

