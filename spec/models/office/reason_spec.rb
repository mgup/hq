require 'spec_helper'

describe Office::Reason do
	
	describe 'обладает связями с другими моделями' do
		it 'с шаблоном' do
			should belong_to(:template)
		end
  
		it 'видов причин' do
			should have_many(:order_reasons)
		end

		it 'видов' do
			should have_many(:orders)
		end

	end
end
