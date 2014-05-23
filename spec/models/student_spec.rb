require 'spec_helper'

describe Student do
  it 'должен обладать валидной фабрикой' do
		build(:student).should be_valid
	end

	describe 'обладает связями с другими моделями:' do
		it 'с именем студента' do
			should belong_to(:person).class_name('Person')
		end

		it 'с группой' do
			should belong_to(:group).class_name('Group')
		end

		it 'с оценкой' do
			should have_many(:marks).class_name('Study::Mark')
		end

		it 'с экзаменами' do
			should have_many(:exams).class_name('Study::Exam')
		end

		it 'с контрольными точками' do
			should have_many(:xmarks).class_name('Study::Xmark')
		end
		it 'с документами студента' do
			should have_many(:document_students).class_name('Document::DocumentStudent')
		end
		it 'с зачетной книжкой' do
			should have_many(:documents).class_name('Document::Doc')
		end
		it 'с платежами' do
			should have_many(:payments).class_name('Finance::Payment')
		end
		it 'с поддержкой' do
			should have_many(:supports).class_name('My::Support')
		end
		
		it 'с выбором специальности' do
			should have_many(:selections).class_name('My::Select')
		end
		it 'с выбором оценки' do
			should have_many(:choices).class_name('My::Choice')
		end
		it 'с порядком студента' do
			should have_many(:students_in_order).class_name('Office::OrderStudent')
		end
		
		it 'с порядком' do
			should have_many(:orders).class_name('Office::Order')
		end
		it 'с посетителями мероприятия' do
			should have_many(:visitor_event_dates)
		end
		it 'с датой' do
			should have_many(:dates).through(:visitor_event_dates)
		end
	it 'со студентом, имеющим ученую степень' do
			should have_many(:graduate_student)
		end
	end
end
