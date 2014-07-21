require 'rails_helper'

describe VisitorEventDate do
  describe 'обладает связями с другими моделями:' do
    it 'с датой' do
      expect belong_to(:date)
    end

    it 'с посетителем' do
      expect belong_to(:visitor)
    end

    it 'с пользователем' do
      expect belong_to(:user)
    end

    it 'со студентом' do
      expect belong_to(:student)
    end
  end
end
