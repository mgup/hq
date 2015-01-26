require 'rails_helper'

describe User do
  it 'должен обладать валидной фабрикой' do
    expect(build(:user)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с назначениями на должность' do
      expect have_many(:positions)
    end

    it 'с ролями' do
      expect have_many(:roles).through(:positions)
    end

    it 'с подразделениями' do
      expect have_many(:departments).through(:positions)
    end

    it 'с таблицей для связи преподавателя и дисциплины' do
      expect have_many(:discipline_teachers)
    end

    it 'с дисциплинами' do
      expect have_many(:disciplines).through(:discipline_teachers)
    end

    it 'с предетами' do
      expect have_many(:subjects).class_name('Study::Subject')
    end

    it 'с достижениями' do
      expect have_many(:achievements)
    end

    it 'с отчетами о достижениях' do
      expect have_many(:achievement_reports)
    end

    it 'с датами' do
      expect have_many(:dates).through(:visitor_event_dates)
    end

    it 'с задачами' do
      expect have_many(:tasks).through(:task_users)
    end

    it 'с пользователями задач' do
      expect have_many(:task_users)
    end

    it 'с группами кураторов' do
      expect have_many(:curator_groups).class_name('Curator::Group')
    end

    it 'с группами' do
      expect have_many(:groups).through(:curator_groups)
    end

    it 'с текущими группами' do
      expect have_many(:current_groups)
    end
  end
end
