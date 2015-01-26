require 'rails_helper'

describe Study::Repeat do
  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      expect belong_to(:exam)
    end

    it 'со студентами' do
      expect have_many(:students)
    end

    it 'с протестующим студентом' do
      expect belong_to(:deprecated_student)
    end
  end
end

