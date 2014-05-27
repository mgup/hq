require 'spec_helper'

describe Study::ExamMark do
  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      should belong_to(:exam)
    end
  end
end
