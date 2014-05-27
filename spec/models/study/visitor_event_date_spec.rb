require 'spec_helper'

describe VisitorEventDate do
  
  describe 'обладает связями с другими моделями:' do
    it 'с датой' do
      should belong_to(:date)
    end
     it 'с посетитель' do
      should belong_to(:visitor)
    end
         it 'с пользователь' do
      should belong_to(:user)
    end
         it 'со студентом' do
      should belong_to(:student)
    end
  end
end

