require 'spec_helper'

describe Hostel::OffenseRoom do

  describe 'обладает связями с другими моделями:' do
    it 'с правонарушением' do
      should belong_to(:offense).class_name('Hostel::ReportOffense')
    end

    it 'с комнатой' do
      should belong_to(:room).class_name('Hostel::Room')
    end

  end
end
