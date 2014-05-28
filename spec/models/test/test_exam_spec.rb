require 'spec_helper'

describe Exam do

  describe 'обладает связями с другими моделями:' do
    it 'с темой' do
      should belong_to(:positions)
    end
    it 'с группой' do
      should belong_to(:group)
    end
    it 'со студентом' do
      should belong_to(:student)
    end
  end
end