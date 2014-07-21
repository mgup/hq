require 'rails_helper'

describe Finance::Payment do
  describe 'обладает связями с другими моделями:' do 
    it 'со студентом' do
      expect belong_to(:student)
    end
  end
end
