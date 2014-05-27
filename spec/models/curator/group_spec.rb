require 'spec_helper'

describe Curator::Group do
  describe 'обладает связями с другими моделями:' do 	
    it 'с куратором' do
       should belong_to(:curator)
    end		
    
    it 'с группой' do
      should belong_to(:group)
    end
  end	
end
