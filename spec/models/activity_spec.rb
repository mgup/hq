require 'spec_helper'

describe Activity do
  describe 'обладает ограничениями на поля' do
    it 'обязательно присутствие названия' do 
      should validate_presence_of(:name)
    end
    
    it 'обязательно наличие идентификатора группы показателей' do 
      should validate_presence_of(:activity_group_id)
    end
    
    it 'обязательно наличие типа показателей' do 
      should validate_presence_of(:activity_type_id)
    end	
  end 	
  
  describe 'обладает связями с другими моделями:' do
    it 'с группой показателей' do
      should belong_to(:activity_group)
    end
    
    it 'с группой' do
      should belong_to(:group)
    end
    
    it 'с активным типом' do
      should belong_to(:activity_type)
    end
  
    it 'с типом начисления баллов' do
      should belong_to(:activity_credit_type)
    end
    
    it 'с достижениями' do
      should have_many(:achievements)
    end
  end
end
