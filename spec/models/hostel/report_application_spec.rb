require 'spec_helper'

describe Hostel::ReportApplication do
  describe 'обладает связями с другими моделями:' do
    it 'с отчетом' do
      should belong_to(Hostel::Report)
    end
  end
end

