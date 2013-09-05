require 'spec_helper'

describe Study::DisciplinesController do
  context 'неавторизованный пользователь' do

  end

  context 'авторизованный пользователь без прав преподавателя' do

  end

  context 'авторизованный преподаватель' do
    before :each do
      @user = create(:user, :lecturer)
      sign_in @user
    end

    describe 'при запросе списка дисциплин' do
      before :each do
        get :index
      end

      it 'должен получить ответ' do
        should respond_with(:success)
      end

      it 'должен видеть страницу со списком дисциплин' do
        should render_template(:index)
      end

      context 'получая дисциплины' do
        before :each do
          @my_lead      = create(:discipline, lead_teacher: @user)
          @my_assistant = create(:discipline, lead_teacher: create(:user, :lecturer))
          @my_assistant.assistant_teachers << @user

          @other = create(:discipline, lead_teacher: create(:user, :lecturer))
        end

        it 'должен получить дисциплины, в которых он ведущий преподаватель' do
          assigns(:disciplines).should include(@my_lead)
        end
        it 'должен получить дисциплины, в которых он дополнительный преподаватель' do
          assigns(:disciplines).should include(@my_assistant)
        end
        it 'не должен получить чужие дисциплины' do
          assigns(:disciplines).should_not include(@other)
        end
      end
    end

    describe 'при создании дисциплины' do
      before :each do
        get :new
      end

      it 'должен получить ответ' do
        should respond_with(:success)
      end

      it 'должен видеть страницу создания дисциплины' do
        should render_template(:new)
      end

      it 'должен получить заготовку для дисциплины' do
        assigns(:discipline).should be_a_new(Study::Discipline)
      end
    end

    describe 'при сохранении новой дисциплины' do
      context 'при отсутствии ошибок в данных дисциплины' do
        before :each do
          @discipline_attrs = build(:discipline,
                                    subject_teacher: @user.id,
                                    subject_group: create(:group).id).attributes
          @discipline_attrs[:final_exam_attributes] = build(:exam, :final).attributes
        end

        it 'должен вызывать создание дисциплины' do
          expect {
            post :create, study_discipline: @discipline_attrs
          }.to change { Study::Discipline.count }.by(1)
        end

        it 'должен переходить на страницу редактирования занятий' do
          post :create, study_discipline: @discipline_attrs
          response.should redirect_to(study_disciplines_path)
        end
      end

      context 'при наличии ошибок в данных дисциплины' do
        it 'не должен вызывать создание дисциплины' do
          expect {
            post :create, study_discipline: attributes_for(:discipline)
          }.to_not change { Study::Discipline.count }.by(1)
        end
        it 'должен видеть форму создания дисциплины' do
          post :create, study_discipline: attributes_for(:discipline)
          should render_template(:new)
        end
      end
    end

    describe 'при редактировании своей дисциплины' do
      before :each do
        @discipline = create(:discipline, lead_teacher: @user)
        get :edit, id: @discipline.id
      end

      it 'должен получить ответ' do
        should respond_with(:success)
      end

      it 'должен видеть страницу редактировании дисциплины' do
        should render_template(:edit)
      end

      it 'должен получать нужную запись' do
        assigns(:discipline).should eql(@discipline)
      end
    end

    describe 'при редактировании чужой дисциплины' do
      it 'должен получать ошибку ActiveRecord::RecordNotFound' do
        discipline = create(:discipline, lead_teacher: create(:user, :lecturer))
        expect {
          get :edit, id: discipline.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'при сохранении изменений в существующую дисциплину' do

  end

   #context 'для разработчиков' do
   #  before :each do
   #    @user = FactoryGirl.create(:developer)
   #    sign_in @user
   #  end
   #
   #  describe 'POST #create' do
   #    context 'в случае успешного создания' do
   #      before :each do
   #        Study::Discipline.any_instance.should_receive(:save).and_return(true)
   #        post :create, discipline: {}
   #      end
   #
   #      it 'должен создавать новую дисциплину' do
   #        flash[:notice].should_not be_nil
   #      end
   #
   #      it 'должно происходить перенаправление на список дисциплин' do
   #        response.should redirect_to study_disciplines_path
   #      end
   #    end
   #
   #    context 'в случае ошибки' do
   #      it 'должен перенаправить на создание' do
   #        Study::Discipline.any_instance.should_receive(:save).and_return(false)
   #        post :create, discipline: {}
   #        response.should render_template :new
   #      end
   #    end
   #  end
   #
   #  describe 'PUT #update' do
   #    before :each do
   #      @discipline = FactoryGirl.create(:discipline_with_controls, subject_teacher: @user.id,
   #                                       group: FactoryGirl.create(:group))
   #    end
   #    context 'в случае успешного изменения' do
   #      before :each do
   #        Study::Discipline.any_instance.should_receive(:update).and_return(true)
   #      end
   #
   #      it 'должен находить правильную дисциплину' do
   #        put :update, id: @discipline
   #        assigns(:discipline).should eq(@discipline)
   #      end
   #
   #      it 'должен переходить на представление с занятиями' do
   #        put :update, id: @discipline
   #        response.should redirect_to study_discipline_checkpoints_path(@discipline)
   #      end
   #    end
   #
   #    #context 'в случае неудачи' do
   #    #   context ', если идёт редактирование контрольных точек, ' do
   #    #      it 'должен перенаправлять на редактирование контрольных точек' do
   #    #        put :update, id: @discipline, checkpoints_attributes: 5
   #    #        response.should render_template 'study/checkpoints/new'
   #    #      end
   #    #    end
   #    #   context ', если не идёт редактирование контрольных точек, ' do
   #    #      it 'должен перенаправлять на редактирование дисциплины' do
   #    #        put :update, id: @discipline, name: nil
   #    #        response.should render_template :edit
   #    #        response.body.should == ''
   #    #      end
   #    #    end
   #    #end
   #  end
   #
   #  describe 'DELETE #destroy' do
   #    before :each do
   #      @discipline = FactoryGirl.create(:discipline, subject_teacher: @user.id,
   #                                       group: FactoryGirl.create(:group))
   #      Study::Discipline.any_instance.should_receive(:destroy).and_return(true)
   #      delete :destroy, id: @discipline
   #    end
   #
   #    it 'должен находить правильную дисциплину' do
   #       assigns(:discipline).should eq(@discipline)
   #       @discipline.id == nil
   #    end
   #    it 'должен перенаправлять на список дисциплин' do
   #      response.should redirect_to study_disciplines_path
   #    end
   #  end
end