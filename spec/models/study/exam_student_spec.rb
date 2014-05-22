require 'spec_helper'

  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      should belong_to(:exam)
    end
    it 'со студентом' do
      should belong_to(:student)
    end
    it 'с экзаменом' do
      should belong_to(:person)
    end