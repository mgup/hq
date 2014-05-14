require 'spec_helper'

describe Study::ProgressController do
  before  do
    @group = FactoryGirl.create(
        :group, speciality: FactoryGirl.create(:speciality, id: 2 + rand(7)))

    @discipline = FactoryGirl.create(:discipline, group: @group)
  end

  describe 'GET #index' do
    before :each do
      get :index, group_id: @group.id
    end

    it 'должен выполняться успешно' do
      response.should be_success
    end

    it 'должен выводить правильное представление' do
      response.should render_template(:index)
    end
  end

  describe 'GET #discipline' do
    before :each do
      @student = FactoryGirl.create(:student, group: @group)

      get :discipline, group_id: @group.id, discipline: @discipline.id
    end

    it 'должен выполняться успешно' do
      response.should be_success
    end

    it 'должен выводить правильное представление' do
      response.should render_template(:discipline)
    end

    it 'должен содержать список студентов в @students' do
      expect(assigns(:students)).to include(@student)
      expect(assigns(:students).length).to be(1)
    end
  end
end
