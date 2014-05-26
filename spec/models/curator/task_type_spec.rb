require 'spec_helper'

describe Curator::TaskType do

	describe 'обладает связями с другими моделями:' do 	
		it 'с заданиями' do
			should has_many(:tasks)
		end		
	end	

	describe 'обладает ограничениями на поля' do
		it 'обязательное поле присутствия имени' do	
			should validate_presence_of(:name)
		end
    end
end