require 'spec_helper'

describe StudentsController do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @student = create(:student)
        get :index
      end
      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

      it 'в выводе должен присутствовать тестовый студент' do
        assigns(:students).should include(@student)
      end
    end

    describe 'GET "show"' do
      before :each do
        @shown = create(:student)
        get :show, id: @shown.id
      end
      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:show)
      end

      it 'должен находить правильного студента' do
        assigns(:student).should eq(@shown)
      end
    end

    #describe 'PUT #update' do
    #  before :each do
    #    @updated = FactoryGirl.create(:student, person: FactoryGirl.create(:person, fname: FactoryGirl.create(:dictionary),
    #                     iname: FactoryGirl.create(:dictionary), oname: FactoryGirl.create(:dictionary)), group: FactoryGirl.create(:group))
    #  end
    #  context 'в случае успешного изменения' do
    #    before :each do
    #      Student.any_instance.should_receive(:update).and_return(true)
    #      put :update, id: @updated, students: {}
    #    end
    #
    #    it 'должен находить правильного студента' do
    #      assigns(:student).should eq(@updated)
    #    end
    #
    #    it 'должен переходить на страницу с данными студента' do
    #      response.should redirect_to @updated
    #    end
    #
    #  end
    #
    #  context 'в случае неудачи' do
    #    it 'должен перенаправлять на редактирование' do
    #      put :update, id: @updated
    #      response.should render_template :show
    #    end
    #  end
    #end
  end

  #context 'для пользователей, не являющихся разработчиками,' do
  #  it 'должен быть переход на главную страницу' do
  #    sign_in FactoryGirl.create(:user)
  #
  #    get :index
  #    response.should redirect_to(root_path)
  #  end
  #end

  context 'для не авторизованных пользователей' do
    it 'должен быть переход на страницу авторизации' do
      sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
    end
  end
end