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

    describe 'при редактировании дисциплины, в которой он дополнительный преподаватель' do
      before :each do
        @discipline = create(:discipline, lead_teacher: create(:user, :lecturer))
        @discipline.assistant_teachers << @user
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

    describe 'при сохранении изменений в дисциплину' do
      context 'при отсутствии ошибок в данных дисциплины' do
        before :each do
          @discipline = create(:discipline, lead_teacher: @user)
          @discipline_attrs = build(:discipline, subject_id: @discipline.id,
                                    lead_teacher: @user, subject_name: 'Some name').attributes
          @discipline_attrs[:final_exam_attributes] = build(:exam, :final).attributes
        end

        it 'должен вызывать редактирование правильной дисциплины' do
          put :update, id: @discipline, study_discipline: @discipline_attrs
          assigns(:discipline).should eq(@discipline)
        end

        it 'должен вносить изменения в дисциплину' do
          put :update, id: @discipline, study_discipline: @discipline_attrs
          @discipline.reload
          @discipline.name.should eq('Some name')
        end

        it 'должен перейти на страницу с занятиями' do
          put :update, id: @discipline, study_discipline: @discipline_attrs
          response.should redirect_to study_discipline_checkpoints_path(@discipline)
        end
      end

      context 'при наличии ошибок в данных дисциплины' do
        before :each do
          @discipline = create(:discipline, lead_teacher: @user)
          @name =  @discipline.name
          @discipline_attrs = build(:discipline, subject_id: @discipline.id,
                                    lead_teacher: @user, subject_name: '').attributes
          @discipline_attrs[:final_exam_attributes] = build(:exam, :final).attributes
        end
        it 'не должен вызывать изменение дисциплины' do
          put :update, id: @discipline, study_discipline: @discipline_attrs
          @discipline.reload
          @discipline.name.should eq(@name)
        end
        it 'должен видеть форму создания дисциплины' do
          put :update, id: @discipline, study_discipline: @discipline_attrs
          should render_template(:edit)
        end
      end

      context 'при наличии ошибок в данных контрольных точек' do
        before :each do
          @discipline = create(:discipline, lead_teacher: @user)
          @old = @discipline
          @checkpoint = create(:checkpoint, :control, discipline: @discipline)
          @discipline_attrs = @discipline.attributes
          @discipline_attrs[:checkpoints_attributes] = {2 => build(:checkpoint, :control,
                                                             checkpoint_subject: @discipline.id,
                                                             checkpoint_max: 90).attributes}
        end
        it 'не должен вызывать изменение дисциплины и контрольных точек' do
          put :update, id: @discipline, study_discipline: @discipline_attrs
          @discipline.reload
          @discipline.should eq(@old)
        end
        it 'должен видеть форму создания контрольных точек' do
          #put :update, id: @discipline, study_discipline: @discipline_attrs
          #should render_template 'study/checkpoints/new'
        end
      end
    end

    describe 'при удалении своей дисциплины' do
      before :each do
        @discipline = create(:discipline, lead_teacher: @user)
      end

      context 'при отсутствии у неё контрольных точек' do
        it 'должен удалить дисциплину' do
          expect {
            delete :destroy, id: @discipline
          }.to change { Study::Discipline.count }.by(-1)
        end

        it 'должен перейти на страницу со списком дисциплин' do
          delete :destroy, id: @discipline
          response.should redirect_to(study_disciplines_path)
        end
      end

      context 'при наличии у неё контрольных точек' do
        before :each do
          @discipline = create(:discipline, lead_teacher: @user)
          create(:checkpoint, :control, discipline: @discipline)
        end

        it 'не должен удалить дисциплину' do
          expect {
            delete :destroy, id: @discipline
          }.not_to change { Study::Discipline.count }.by(-1)
        end

        it 'должен перейти на страницу со списком дисциплин' do
          delete :destroy, id: @discipline
          response.should redirect_to(study_disciplines_path)
        end
      end
    end

    describe 'при удалении дисциплины, в которой он дополнительный преподаватель' do
      before :each do
        @discipline = create(:discipline, lead_teacher: create(:user, :lecturer))
        @discipline.assistant_teachers << @user
      end

      context 'при отсутствии у неё контрольных точек' do
        it 'должен удалить дисциплину' do
          expect {
            delete :destroy, id: @discipline
          }.to change { Study::Discipline.count }.by(-1)
        end

        it 'должен перейти на страницу со списком дисциплин' do
          delete :destroy, id: @discipline
          response.should redirect_to(study_disciplines_path)
        end
      end

      context 'при наличии у неё контрольных точек' do
        before :each do
          create(:checkpoint, :control, discipline: @discipline)
        end

        it 'не должен удалить дисциплину' do
          expect {
            delete :destroy, id: @discipline
          }.not_to change { Study::Discipline.count }.by(-1)
        end

        it 'должен перейти на страницу со списокм дисциплин' do
          delete :destroy, id: @discipline
          response.should redirect_to(study_disciplines_path)
        end
      end
    end

    describe 'при удалении чужой дисциплины' do
      it 'должен получить ошибку ActiveRecord::RecordNotFound' do
        discipline = create(:discipline, lead_teacher: create(:user, :lecturer))
        expect {
          delete :destroy, id: discipline
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end