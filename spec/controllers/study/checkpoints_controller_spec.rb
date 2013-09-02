require 'spec_helper'

describe Study::CheckpointsController do
  context 'для разработчиков' do
    before do
      @user = FactoryGirl.create(:developer)
      sign_in @user
      @discipline = FactoryGirl.create(:discipline_with_controls,  subject_teacher: @user.id, group: FactoryGirl.create(:group))
    end

    describe 'GET #index' do
      before :each do
        #@checkpoint = FactoryGirl.create(:checkpoint, checkpoint_subject: @discipline.id)
        get :index, discipline_id: @discipline
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

    end

    describe 'GET #new' do
      before :each do
        get :new, discipline_id: @discipline
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:new)
      end

      it 'должна генерироваться форма для дисциплины' do
        assigns(:discipline).should eq(@discipline)
      end

    end

    #describe 'GET #show' do
    #  before :each do
    #    @checkpoint = @discipline.checkpoints.first
    #
    #  end
    #
    #  context 'if params[:study_checkpoint]' do
    #    before :each do
    #      get :show, discipline_id: @discipline, id: @checkpoint,
    #          params: {study_checkpoint: {checkpoint_type: 3, date: Date.today,
    #                                      name: 'aaa', details: 'gfg shjb sh',
    #                                      max: 20, min: 11}}
    #      Study::Discipline.any_instance.should_receive(:update).and_return(true)
    #    end
    #
    #    it 'должен находить правильную контрольную точку' do
    #      assigns(:checkpoint).should eq(@checkpoint)
    #    end
    #
    #    it 'должен переходить на представление с занятиями' do
    #      response.should redirect_to study_discipline_checkpoints_path(@discipline)
    #    end
    #  end
    #end
  end

  #context 'для пользователей, не являющихся разработчиками,' do
  #  it 'должен быть переход на страницу авторизации' do
  #    sign_in FactoryGirl.create(:user)
  #
  #    get :index
  #    response.should redirect_to(new_user_session_path)
  #  end
  #end

  #context 'для не авторизованных пользователей' do
  #  it 'должен быть переход на страницу авторизации' do
  #    sign_out :user
  #
  #    get :index
  #    response.should redirect_to(new_user_session_path)
  #  end
  #end
end