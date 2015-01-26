require 'rails_helper'

describe Position do
	it 'должен обладать валидной фабрикой' do
		expect(build(:position)).to be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с пользователем' do
			expect belong_to(:user)
		end

		it 'с ролями' do
			expect belong_to(:role)
		end

		it 'с подразделениями' do
			expect belong_to(:department)
		end

		it 'с назначениями' do
			expect belong_to(:appointment)
		end
	end
end
