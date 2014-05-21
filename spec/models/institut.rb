require 'spec_helper'

describe Institut do
  it 'со специальностью' do
    should belong_to(:faculty)
  end

  it 'с группами' do
      should have_many(:groups)
    end

    
  end
end
