require 'rails_helper'

describe Curator::Group do
  describe 'обладает связями с другими моделями:' do 	
    it 'с куратором' do
      expect belong_to(:curator)
    end		
    
    it 'с группой' do
      expect belong_to(:group)
    end
  end	
end
