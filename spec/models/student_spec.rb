require 'spec_helper'

describe Student do
	it 'должен обладать валидной фабрикой' do
		build(:student).should be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с персонами' do
			should belong_to(:person)
		end

		it 'с группой' do
			should belong_to(:group)
		end

		it 'с оценками' do
			should have_many(:marks)
		end

		it 'с экзаменами' do
			should have_many(:exams)
		end

		it 'с xmarks' do
			should have_many(:xmarks)
		end

		# продолжение следует
	end
end