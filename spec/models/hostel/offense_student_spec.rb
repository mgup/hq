require 'spec_helper'

describe Hostel::OffenseStudent do
	it 'должен обладать валидной фабрикой' do
		build(:hostel_report_offense_student).should be_valid
	end
	describe 'обладает связями с другими моделями:' do
		it 'с правонарушением' do
			should belong_to(:offense).class_name('Hostel::ReportOffense')
		end
		it 'с человеком' do
			should belong_to(:person).class_name('Person')
		end
	end
end