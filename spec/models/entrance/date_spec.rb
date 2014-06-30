require 'spec_helper'

describe Entrance do
  describe 'обладает связями с другими моделями:' do
    it 'c приемной кампанией' do
      expect have_many(:campaign)
    end

    it 'с формой образования' do
      expect belong_to(:education_form)
    end

    it 'с типом образования' do
      expect belong_to(:education_type)
    end

    it 'с пройденым образованием' do
      expect belong_to(:education_source)
    end
  end
end
