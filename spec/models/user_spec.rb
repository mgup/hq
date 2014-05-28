require 'spec_helper'

describe User do
  it 'должен обладать валидной фабрикой' do
    build(:user).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с назначениями на должность' do
      should have_many(:positions)
    end

    it 'с ролями' do
      should have_many(:roles).through(:positions)
    end

    it 'с подразделениями' do
      should have_many(:departments).through(:positions)
    end

    it 'с таблицей для связи преподавателя и дисциплины' do
      should have_many(:discipline_teachers)
    end

    it 'с дисциплинами' do
      should have_many(:disciplines).through(:discipline_teachers)
    end

    it 'с предетами' do
      should have_many(:subjects).class_name('Study::Subject')
    end
    
    it 'с достижениями' do
      should have_many(:achievements)
    end
    
    it 'с отчетами о достижениях' do
      should have_many(:achievement_reports)
    end

    it 'с датами' do
      should have_many(:dates).through(:visitor_event_dates)
    end
    
    it 'с задачами' do
      should have_many(:tasks).through(:task_users)
    end
    
    it 'с пользователями задач' do
      should have_many(:task_users)
    end
    
    it 'с группами кураторов' do
      should have_many(:curator_groups).class_name('Curator::Group')
    end
    
    it 'с группами' do
      should have_many(:groups).through(:curator_groups)
    end
    
    it 'с текущими группами' do
      should have_many(:current_groups)
    end
  end
end
