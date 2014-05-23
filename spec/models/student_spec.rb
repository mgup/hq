require 'spec_helper'

describe Student do
  it 'должен обладать валидной фабрикой' do
		build(:student).should be_valid
	end

	describe 'обладает связями с другими моделями:' do
		it 'с человеком' do
			should belong_to(:person).class_name('Person')
		end

		it 'с группой' do
			should belong_to(:group).class_name('Group')
		end

		it 'с оценками' do
			should have_many(:marks).class_name('Study::Mark')
		end

		it 'с экзаменами' do
			should have_many(:exams).class_name('Study::Exam')
		end

		it 'с оценками (сессии)' do
			should have_many(:xmarks).class_name('Study::Xmark')
		end
		
		it 'с таблицей, обеспечивающей связь с документами' do
			should have_many(:document_students).class_name('Document::DocumentStudent')
		end
		
		it 'с документами' do
			should have_many(:documents).class_name('Document::Doc').through(:document_students)
		end
		
		it 'с платежами' do
			should have_many(:payments).class_name('Finance::Payment')
		end
		
		it 'с заявлениями на материальную помощь' do
			should have_many(:supports).class_name('My::Support')
		end
		
		it 'с таблицей, обеспечивающей связь с предметами по выбору' do
			should have_many(:selections).class_name('My::Select')
		end
		
		it 'с предметами по выбору' do
			should have_many(:choices).class_name('My::Choice').through(:selections)
		end
		
		it 'с таблицей, обеспечивающей связь с приказами' do
			should have_many(:students_in_order).class_name('Office::OrderStudent')
		end
		
		it 'с приказами' do
			should have_many(:orders).class_name('Office::Order').through(:students_in_order)
		end
		
		it 'с таблицей, обеспечивающей связь с датами мероприятий' do
			should have_many(:visitor_event_dates).class_name('VisitorEventDate')
		end
		
		it 'с датами мероприятий' do
			should have_many(:dates).class_name('EventDate').through(:visitor_event_dates)
		end
		
		it 'с таблицей, обеспечивающей связь с дипломом' do
			should have_one(:graduate_student)
		end
	end
end
