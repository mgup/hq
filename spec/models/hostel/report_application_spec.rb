require 'spec_helper'

describe Hostel::Report_application do
  describe 'обладает связями с другими моделями:' do
    it 'с отчетами' do
      should belong_to(:report)
    end
  end
end

