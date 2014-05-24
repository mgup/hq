require 'spec_helper'

describe Finance::Payment do
	it 'должен обладать валидной фабрикой' do
		build(:finance_payment).should be_valid
	end

	describe 'обладает связями с другими моделями:' do 
		it 'со студентом' do
			should belong_to(:student)
		end
    end
end