require 'spec_helper'

describe Hostel::ReportOffense do
  it 'должен обладать валидной фабрикой' do
    build(:hostel_report_offense).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с отчетом' do
      should belong_to(:report).class_name('Hostel::Report')
    end
    it 'с правонарушением' do
      should belong_to(:offense).class_name('Hostel::Offense')
    end

    it 'с offense_rooms' do
      should have_many(:offense_rooms).class_name('Hostel::OffenseRoom')
    end

    it 'с комнатами' do
      should have_many(:rooms).class_name('Hostel::Room').through(:offense_rooms)
    end

    it 'со студентами-праконарушителями' do
      should have_many(:offense_students).class_name('Hostel::OffenseStudent')
    end

    it 'с persons' do
      should have_many(:persons).class_name('Person').through(:offense_students)
    end

  end
end