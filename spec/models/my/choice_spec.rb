require 'spec_helper'

describe My::Choice do
  describe 'обладает связями с другими моделями:' do 
    it 'с выбором' do
      should have_many(:selections)
    end
    
    it 'со студентами' do
      should have_many(:students)
    end
  end
end

