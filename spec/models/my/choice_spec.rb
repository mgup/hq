require 'rails_helper'

describe My::Choice do
  describe 'обладает связями с другими моделями:' do 
    it 'с выбором' do
      expect have_many(:selections)
    end
    
    it 'со студентами' do
      expect have_many(:students)
    end
  end
end

