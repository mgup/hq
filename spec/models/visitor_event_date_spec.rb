require 'spec_helper'

describe VisitorEventDate do
	it 'должен обладать валидной фабрикой' do
		build(:position).should be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с датой' do
			should belong_to(:date)
		end

		it 'с незарегистрированными пользователями' do
			should belong_to(:visitor)
		end

		it 'с пользователями' do
			should belong_to(:user)
		end

		it 'со студентом' do
			should belong_to(:student)
		end
	end
end
