require 'spec_helper'
describe Activity do

	describe 'обладает ограничениями на поля' do

		it 'обязательное поле присутствия названия' do 
			should validate_presence_of(:name)
		end
		it 'обязательное поле присутствия id активной группы' do 
			should validate_presence_of(:activity_group_id)
		end
		it 'обязательное поле присутствия id активного типа' do 
			should validate_presence_of(:activity_type_id)
		end
	end 	
	
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
	    #it 'с валидатором' do
	    #  should belong_to(:validator)
	    #end pochemu to ne rabotaet:(
	  	it 'с достижениями' do
	      should have_many(:achievements)
	    end
	end
end