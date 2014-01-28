require 'spec_helper'

describe SpecialitiesController do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @speciality = FactoryGirl.create(:speciality)
        get :index
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

      it 'в выводе должна присутствовать тестовая специальность' do
        assigns(:specialities).should include(@speciality)
      end
    end

    describe 'GET #new' do
      before :each do
        get :new
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:new)
      end

      it 'должен содержать новую запись' do
        assigns(:speciality).new_record?.should be_true
      end
    end

    #describe 'POST #create' do
    #  context 'в случае успешного создания' do
    #    before :each do
    #      post :create, speciality: {name: Faker::Lorem.sentence,
    #                          speciality_code: '111111',
    #                          type: rand(2), suffix: 'xxx',
    #                          speciality_shortname: 'xx',
    #                          speciality_olength: 0,
    #                          speciality_zlength: 0,
    #                          speciality_ozlength: 0,
    #                          speciality_faculty: FactoryGirl.create(:department).id}
    #      Speciality.any_instance.should_receive(:save).and_return(true)
    #    end
    #
    #    it 'должен создавать новую специальность' do
    #      flash[:notice].should_not be_nil
    #    end
    #
    #    it 'должно происходить перенаправление на страницу со специальностями' do
    #      response.should redirect_to specialities_path
    #    end
    #  end
    #
    #  context 'в случае ошибки' do
    #    it 'должен перенаправить на создание' do
    #      post :create, speciality: {}
    #      Speciality.any_instance.should_receive(:save).and_return(false)
    #      response.should render_template :new
    #    end
    #  end
    #end
  end

  context 'для пользователей, не являющихся разработчиками,' do
    it 'должен быть переход на главную страницу' do
      sign_in FactoryGirl.create(:user)

      get :index
      response.should redirect_to(root_path)
    end
  end

  context 'для не авторизованных пользователей' do
    it 'должен быть переход на страницу авторизации' do
      sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
    end
  end
end