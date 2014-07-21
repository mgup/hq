require 'rails_helper'

describe Study::ExamFormreader do
  describe 'обладает связями с другими моделями:' do
    it 'с экзаменом' do
      expect belong_to(:exam)
    end
  end
end

