require 'spec_helper'

describe Curator::Task do
	it 'должен обладать валидной фабрикой' do
		build(:curator_task).should be_valid
	end

	describe 'обладает связями с другими моделями:' do 
		it 'с типом задания' do
			should belong_to(:type)
		end
		it 'с индивидуальным заданием' do
			should have_many(:task_users)
		end
		it 'с пользователем' do
			should have_many(:users)
		end		
    end
end