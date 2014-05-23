require 'spec_helper'
describe Activity do
	
	describe 'обладает связями с другими моделями:' do
	    it 'с активной группой' do
	      should belong_to(:activity_group)
	    end

	    it 'с группой' do
	      should belong_to(:group)
	    end

	  it 'с активным типом' do
	      should belong_to(:activity_type)
	    end

	    it 'с активным кредитным типом' do
	      should belong_to(:activity_credit_type)
	    end

  		it 'с достижениями' do
	      should have_many(:achievements)
	    end
	end
end
