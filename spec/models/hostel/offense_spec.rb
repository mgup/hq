require 'spec_helper'

describe Hostel::Offense do

	describe 'обладает связями с другими моделями:' do 	
		it 'с отчетами правонарушений' do
			should have_many(:report_offenses)
		end		
		it 'с правонарушениями' do
			should belong_to(:reports)
		end
	end	

	describe 'содержит типы:' do
		it 'по умолчанию' do
			should scopes(:default)
		end
		it 'для студентов' do
			should scopes(:for_student)
		end
	end
 end