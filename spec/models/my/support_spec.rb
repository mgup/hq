require 'spec_helper'

describe My::Support do
  describe 'обладает связями с другими моделями:' do 
    it 'со студентом' do
      should belong_to(:student)
    end
    
    it 'с опциями' do
      should have_many(:options)
    end
    
    it 'с причинами' do
      should have_many(:causes)
    end
  end
end

