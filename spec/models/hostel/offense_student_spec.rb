require 'spec_helper'

describe Hostel::OffenseStudent do
	describe 'обладает связями с другими моделями:' do
		it 'с человеком' do
			should belong_to(:person).class_name('Person')
		end
	end
end