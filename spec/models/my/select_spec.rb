require 'spec_helper'

describe My::Select do
  describe 'обладает связями с другими моделями:' do 
    it 'с выбором' do
      should belong_to(:choice)
    end
    
    it 'со студентами' do
      should belong_to(:student)
    end
  end
end

