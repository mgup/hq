require 'spec_helper'

describe EventDate do
	
	describe 'обладает связями с другими моделями' do
		it 'с событием' do
			should belong_to(:event)
		end

		it 'с посетителями события' do
			should belong_to(:visitor_event_dates)
		end

		it 'пользователей' do
			should have_many(:users)
		end

		it 'студентов' do
			should have_many(:students)
		end
	end
	
end
