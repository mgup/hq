require 'spec_helper'

describe EventDate do
	it 'должен обладать валидной фабрикой' do
		build(:EventDate).should be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с пользователем' do
			should belong_to(:event)
		end

		it 'с ролями' do
			should belong_to(:class_name)
		end

		it 'с подразделениями' do
			should has_many(:visitor_event_dates)
		end

		it 'с назначениями' do
			should has_many(:users)
		end

		it 'с назначениями' do
			should has_many(:students)
		end
	end
end
