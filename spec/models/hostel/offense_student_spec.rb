require 'rails_helper'

describe Hostel::OffenseStudent do
	describe 'обладает связями с другими моделями:' do
		it 'с человеком' do
			expect belong_to(:person).class_name('Person')
		end
	end
end
