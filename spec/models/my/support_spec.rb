require 'rails_helper'

describe My::Support do
  describe 'обладает связями с другими моделями:' do 
    it 'со студентом' do
      expect belong_to(:student)
    end
    
    it 'с опциями' do
      expect have_many(:options)
    end
    
    it 'с причинами' do
      expect have_many(:causes)
    end
  end
end

