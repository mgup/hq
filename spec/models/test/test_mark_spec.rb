require 'spec_helper'

describe Test_Mark do
  describe 'обладает связями с другими моделями:' do
    it 'со студентом' do
      should belong_to(:student)
    end

    it 'с экзаменом' do
      should belong_to(:exam)
    end
  end
end