require 'rails_helper'

describe Hostel::ReportOffense do
  describe 'обладает связями с другими моделями:' do
    it 'с отчетом' do
      expect belong_to(:report).class_name('Hostel::Report')
    end
    
    it 'с offense_rooms' do
      expect have_many(:offense_rooms).class_name('Hostel::OffenseRoom')
    end
    
    it 'с комнатами' do
      expect have_many(:rooms).class_name('Hostel::Room').through(:offense_rooms)
    end
    
    it 'со студентами-праконарушителями' do
      expect have_many(:offense_students).class_name('Hostel::OffenseStudent')
    end
    
    it 'с persons' do
      expect have_many(:persons).class_name('Person').through(:offense_students)
    end
  end
end
