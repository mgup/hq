require 'spec_helper'

describe Person do
	it 'должен обладать валидной фабрикой' do
		build(:student).should be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с фамилией' do
			should belong_to(:fname)
		end

		it 'с именем' do
			should belong_to(:iname)
		end

		it 'с отчеством' do
			should have_many(:oname)
		end

		it 'с с комнатой' do
			should have_many(:room)
		end

		it 'со студентами' do
			should have_many(:students)
		end

		it 'с document_students' do
			should have_many(:document_students)
		end

end		
end