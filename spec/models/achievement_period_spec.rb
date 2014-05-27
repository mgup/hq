require 'spec_helper'

describe Activity do
  describe 'должен обладать' do
    it 'достижениями' do 
      should have_many(:achievements)
    end
    
    it 'отчетами о достижениях' do
      should have_many(:achievement_reports)
    end
  end
end
      
