require 'spec_helper'

describe GraduateMark do
  describe 'обладает связями с другими моделями:' do
    it 'со студентом-выпускником' do
			should belong_to(:graduate_student)
		end
		
		it 'со graduate_subject' do
			should belong_to(:graduate_subject)
		end
	end
end
1
