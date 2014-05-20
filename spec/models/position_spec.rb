require 'spec_helper'

describe Position do
	it 'должен обладать валидной фабрикой' do
		build(:position).should be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с пользователем' do
			should belong_to(:user)
		end

		it 'с ролями' do
			should belong_to(:role)
		end

		it 'с подразделениями' do
			should belong_to(:department)
		end

		it 'с назначением' do
			should belong_to(:appointment)
		end
	end
end
