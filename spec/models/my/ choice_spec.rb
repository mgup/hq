require 'spec_helper'

describe My::Choice do
	it 'должен обладать валидной фабрикой' do
		build(:optional).should be_valid
	end

	describe 'обладает разделами' do
		it 'с пользователем' do
			should have_many(:selections).class_name('Study::Discipline')
		end

		it 'со студентами' do
			should have_many(:students).though(:selections)
		end
	end
end
