require 'rails_helper'

describe My::Select do
  describe 'обладает связями с другими моделями:' do 
    it 'с выбором' do
      expect belong_to(:choice)
    end
    
    it 'со студентами' do
      expect belong_to(:student)
    end
  end
end

