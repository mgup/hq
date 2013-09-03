require 'spec_helper'

describe Study::GroupsController do
  before  do
    @group = FactoryGirl.create(:group)
  end

  describe 'GET #index' do
    before :each do
      get :index
    end

    it 'должен выполняться успешно' do
      response.should be_success
    end

    it 'должен выводить правильное представление' do
      response.should render_template(:index)
    end

  end

  #describe 'POST #create' do
  #  before :each do
  #    post :create, id: @group.id
  #  end
  #
  #  it 'должно происходить перенаправление на успеваемость' do
  #    response.should redirect_to study_group_progress_path(@group.id)
  #  end
  #
  #end

end