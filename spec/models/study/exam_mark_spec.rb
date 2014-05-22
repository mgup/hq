require 'spec_helper'

  describe 'обладает связями с другими моделями:' do
	    it 'с экзаменом' do
	      should belong_to(:exam)
	    end
	end
