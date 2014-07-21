require 'rails_helper'

describe Person do
  it 'должен обладать валидной фабрикой' do
		expect(build(:student)).to be_valid
	end

	describe 'обладает связями с другими моделями:' do
		it 'с фамилией' do
			expect belong_to(:fname)
		end

		it 'с именем' do
			expect belong_to(:iname)
		end

		it 'с отчеством' do
			expect belong_to(:oname)
		end

		it 'с комнатой' do
			expect belong_to(:room)
		end

		it 'со студентами' do
			expect have_many(:students)
		end
	end
end
