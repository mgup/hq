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

		it 'с document_students' do
			should have_many(:document_students)
		end

		it 'с documents' do
			should have_many(:documents)
		end

		# it 'с платежами' do
		# 	should have_many(:payments)
		# end
		# something going wrong here

		it 'с supports' do
			should have_many(:supports)
		end

		it 'с selections' do
			should have_many(:selections)
		end

		it 'с choices' do
			should have_many(:choices)
		end

		it 'с students_in_order' do
			should have_many(:students_in_order)
		end

		it 'с orders' do
			should have_many(:orders).through(:students_in_order)
		end

		it 'с visitor_event_dates' do
			should have_many(:visitor_event_dates)
		end

		it 'с dates' do
			should have_many(:dates).through(:visitor_event_dates)
		end

		it 'с graduate_student' do
			should have_one(:graduate_student)
		end
		
	end
end