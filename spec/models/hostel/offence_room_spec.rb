require 'spec_helper'

describe Hostel::OffenseRoom do
  it 'должен обладать валидной фабрикой' do
    build(:hostel_report_offense_room).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с правонарушением' do
      should belong_to(:offence).class_name('Hostel::ReportOffense')
    end

    it 'с комнатой' do
      should belong_to(:room).class_name('Hostel::Room')
    end

  end
end