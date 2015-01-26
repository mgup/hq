require 'rails_helper'

describe Document::Doc do
  describe 'должен обладать связями с:' do
    it 'студентами' do
      expect have_many(:students)
    end

    it 'группой' do
      expect have_many(:metas).class_name('Document::Meta')
    end
  end
end
