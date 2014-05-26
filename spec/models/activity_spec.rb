require 'spec_helper'

  describe Activity do
   it 'должен обладать валидной фабрикой' do
    build(:activity).should be_valid
  end
  
  describe 'обладает связями с другими моделями:' do
    it 'с группой нагрузки' do
      should belong_to(:activity_group)
    end
    
   it 'с группой' do
     should belong_to(:group)
   end
   
   it 'с типом активности' do
     should belong_to(:activity_type)
   end
   
   
end
    
  
  
    
    
