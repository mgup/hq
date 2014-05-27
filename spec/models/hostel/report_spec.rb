require 'spec_helper'

describe Hostel::Report do
  describe 'обладает связями с другими моделями:' do 	
    it 'с квартирой' do
      should belong_to(:flat)
    end		
		
    it 'с человеком' do
      should belong_to(:user)
    end

    it 'с отчетами правонарушений' do
      should have_many(:report_offenses)
    end
    
    it 'с правонарушениями' do
      should have_many(:offenses)
    end
		
    it 'заявками' do
      should have_many(:applications)
    end
  end
  
  describe 'обладает ограничениями на поля:' do
    it 'обязательное поле присутствия номера квартиры' do	
      should validate_presence_of(:flat_id)
    end
    
    it 'обязательное поле присутствия даты' do	
      should validate_presence_of(:date)
    end
    
    it 'обязательное поле присутствия времени' do	
      should validate_presence_of(:time)
    end
  end
  
  describe 'принимает вложенные аттрибуты для моделей' do
    it 'отчетов правонарушений' do
      should accept_nested_attributes_for(:report_offenses)
    end
  
    it 'заяаок' do
      should accept_nested_attributes_for(:applications)
    end
  end
end
