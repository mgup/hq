require 'rails_helper'

describe Hostel::ReportApplication do
  describe 'обладает связями с другими моделями:' do
    it 'с отчетом' do
      expect belong_to(:report)
    end		
  end
end

