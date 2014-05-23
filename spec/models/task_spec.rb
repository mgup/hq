require 'spec_helper'

describe Curator do

	it 'должен обладать валидной фабрикой' do
		build(:curator_task).should be_valid
	end

	describe 'обладает связями с другими моделями' do 

		it 'с задачами пользователей' do
			should have_many(:task_users)
		end

		it 'с пользователями' do
			should have_many(:users).through(:task_users)
		end

		it 'с типом' do
			should belong_to(:type)
		end
    end
end
