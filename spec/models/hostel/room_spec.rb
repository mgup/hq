require 'spec_helper'

describe Hostel::Room do
  describe 'обладает связями с другими моделями:' do 	
    it 'с квартирой' do
      should belong_to(:flat)
    end
    
    it 'с жителями' do
      should have_many(:residents)
    end	
  end
end

