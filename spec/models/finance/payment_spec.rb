require 'spec_helper'

describe Finance::Payment do
  describe 'обладает связями с другими моделями:' do 
    it 'со студентом' do
      should belong_to(:student)
    end
  end
end
