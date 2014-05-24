require 'spec_helper'

describe Finance::Price do
	describe 'обладает связями с другими моделями:' do 
		it 'с типом' do
			should belong_to(:type)
		end
    end
end