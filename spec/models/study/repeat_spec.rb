require 'spec_helper'

describe Study::Repeat do
  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      should belong_to(:exam)
    end

    it 'со студентами' do
      should have_many(:students)
    end
    
    it 'со студентами' do
      should belong_to(:students)
    end
    
    it 'с протестующим студентом' do
      should belong_to(:deprecated_student)
    end
  end
end

