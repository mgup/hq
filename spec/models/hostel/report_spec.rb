require 'rails_helper'

describe Hostel::Report do
  describe 'обладает связями с другими моделями:' do 	
    it 'с квартирой' do
      expect belong_to(:flat)
    end		
		
    it 'с человеком' do
      expect belong_to(:user)
    end

    it 'с отчетами правонарушений' do
      expect have_many(:report_offenses)
    end
    
    it 'с правонарушениями' do
      expect have_many(:offenses)
    end
		
    it 'заявками' do
      expect have_many(:applications)
    end
  end
  
  describe 'обладает ограничениями на поля:' do
    it 'обязательное поле присутствия номера квартиры' do	
      expect validate_presence_of(:flat_id)
    end
    
    it 'обязательное поле присутствия даты' do	
      expect validate_presence_of(:date)
    end
    
    it 'обязательное поле присутствия времени' do	
      expect validate_presence_of(:time)
    end
  end
  
  describe 'принимает вложенные аттрибуты для моделей' do
    it 'отчетов правонарушений' do
      expect accept_nested_attributes_for(:report_offenses)
    end
  
    it 'заяаок' do
      expect accept_nested_attributes_for(:applications)
    end
  end
end
