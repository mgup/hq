require 'spec_helper'

describe Study::ExamFormreader do
 	it 'должен обладать валидной фабрикой' do
		build(:exam_formreader).should be_valid
	end

    describe 'обладает связями с другими моделями:' do
 	    it 'с экзаменом' do
 	      should belong_to(:exam)
 	    end
 	end
 end
