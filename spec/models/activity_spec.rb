require 'spec_helper'
describe Activity do
	
	describe 'обладает связями с другими моделями:' do
	    it 'с груповой деятельностью' do
	      should belongs_to(:activity_group)
	    end

	    it 'с группой' do
	      should belongs_to(:group)
	    end

	  	it 'с типом деятельности' do
	      should belongs_to(:activity_type)
	    end

	    it 'с типом кредитной деятельности' do
	      should belongs_to(:activity_credit_type)
	    end

	    it 'с валидатором' do
	      should belongs_to(:validator)
	    end
	    
  		it 'с достижениями' do
	      should have_many(:achievements)
	    end
	end
end
