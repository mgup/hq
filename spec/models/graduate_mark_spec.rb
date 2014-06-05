require 'spec_helper'

describe GraduateMark do
  describe 'обладает связями с другими моделями:' do
    it 'со студентом-выпускником' do
			expect belong_to(:graduate_student)
		end
		
		it 'со graduate_subject' do
			expect belong_to(:graduate_subject)
		end
	end
end
