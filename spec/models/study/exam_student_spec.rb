require 'spec_helper'
describe Study::ExamStudent do
  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      should belong_to(:exam)
    end

    it 'со студентом' do
      should belong_to(:student)
    end

    it 'с персоной' do
      should belong_to(:person)
    end
  end
end
