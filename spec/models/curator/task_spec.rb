require 'rails_helper'

describe Curator::Task do
  describe 'обладает связями с другими моделями:' do 
    it 'с типом задания' do
      expect belong_to(:type)
    end
    
    it 'с индивидуальным заданием' do
      expect have_many(:task_users)
    end
    
    it 'с пользователями' do
      expect have_many(:users)
    end		
  end

  describe 'обладает ограничениями на поля' do
    it 'обязательное поле присутствия названия' do	
      expect validate_presence_of(:name)
    end
    
    it 'обязательное поле присутствия статуса' do
      expect validate_presence_of(:status)
    end
    
    it 'обязательное поле присутствия типа' do
      expect validate_presence_of(:type)
    end
  end
end
