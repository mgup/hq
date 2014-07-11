require 'rails_helper'

describe Hostel::OffenseRoom do
	describe 'обладает связями с другими моделями:' do
		it 'с комнатой' do
			expect belong_to(:room).class_name('Hostel::Room')
		end
	end
end
