require 'spec_helper'

describe Hostel::Offense do

	describe 'обладает связями с другими моделями:' do 	
		it 'с отчетами правонарушений' do
			should have_many(:report_offenses)
		end		
		it 'с правонарушениями' do
			should have_many(:reports)
		end
	end	
 end