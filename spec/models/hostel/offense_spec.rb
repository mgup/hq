require 'rails_helper'

describe Hostel::Offense do
  describe 'обладает связями с другими моделями:' do 	
    it 'с отчетами правонарушений' do
      expect have_many(:report_offenses)
    end
		
    it 'с отчетами' do
      expect have_many(:reports)
    end
  end
end
