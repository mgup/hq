require 'spec_helper'

describe Hostel::Offense do

	describe 'обладает связями с другими моделями:' do 	
		it 'с отчетами правонарушений' do
			should have_many(:report_offenses)
		end		
		it 'с правонарушениями' do
			should belong_to(:reports).through(:report_offenses)
		end
	end	

	describe 'содержит типы:' do
		it 'по умолчанию' do
			should scope(:default)
		end
		it 'для студентов' do
			should scope(:for_student)
		end
	end
 end