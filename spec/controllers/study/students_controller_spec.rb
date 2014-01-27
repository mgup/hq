require 'spec_helper'

describe Study::StudentsController do
  before  do
    @group = FactoryGirl.create(:group)
    @student = FactoryGirl.create(:student, person: FactoryGirl.create(:person, fname: FactoryGirl.create(:dictionary),
                                                                       iname: FactoryGirl.create(:dictionary), oname: FactoryGirl.create(:dictionary)), group: @group)
  end

  describe 'GET #show' do
    before :each do
      get :show, group_id: @group.id, id: @student.id
    end

    it 'должен выполняться успешно' do
      response.should be_success
    end

    it 'должен выводить правильное представление' do
      response.should render_template(:show)
    end

    it 'должен находить правильного студента' do
      assigns(:student).should == @student
    end

  end

  describe 'GET #discipline' do
    before :each do
      user = FactoryGirl.create(:user)
      @discipline = FactoryGirl.create(:discipline, lead_teacher: user,
                                       group: @group)
      get :discipline, group_id: @group.id, id: @student.id, discipline: @discipline.id
    end

    it 'должен выполняться успешно' do
      response.should be_success
    end

    it 'должен выводить правильное представление' do
      response.should render_template(:discipline)
    end

  end

end