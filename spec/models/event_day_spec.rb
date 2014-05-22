require 'spec_helper'

describe EventDate do
	it 'должен обладать валидной фабрикой' do
		build(:event_date).should be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с событием' do
			should belong_to(:event)
		end

		it 'с посетителями события' do
			should belong_to(:visitor_event_dates)
		end
	end
	describe 'имеет много' do
		it 'пользователей' do
			should has_many(:users)
		end

		it 'студентов' do
			should has_many(:students)
		end
	end
	
end
