require 'spec_helper'

describe Study::MarksController do
  context 'для авторизованных преподавателей' do
    before do
      @discipline = create(:exam, :final).discipline
      @checkpoint = create(:checkpoint, :control, discipline: @discipline)
      @student = create(:student, group: @discipline.group)
      @other_student = create(:student, group: @discipline.group)
      sign_in @discipline.lead_teacher
    end

    describe 'GET "index"' do
      before :each do
        @mark = create(:mark, :checkpoint,  student: @student, checkpoint: @checkpoint)
        get :index, discipline_id: @discipline.id, checkpoint_id: @checkpoint.id
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

      it 'в выводе должна присутствовать тестовая оценка' do
        assigns(:marks).should include(@mark)
      end
    end

    describe 'POST #create' do
      context 'если переданы параметры,' do
        before :each do
          post :create, discipline_id: @discipline, checkpoint_id: @checkpoint,
               marks: [{mark: 2001, student: @other_student.id},
                       {mark: 2004, student: @student.id}]
        end

        it 'оценки должны сохраняться' do
          @checkpoint.marks.should_not be_blank
        end

        it 'должно происходить перенаправление на оценки' do
          response.should redirect_to study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
        end
      end
      context 'если переданы параметры,' do
        before :each do
          post :create, discipline_id: @discipline, checkpoint_id: @checkpoint,
               marks: []
        end

        it 'не должен сохранять оценки' do
          @checkpoint.marks.should be_blank
        end

        it 'должно происходить перенаправление на оценки' do
          response.should redirect_to study_discipline_checkpoint_marks_path(@discipline, @checkpoint)
        end
      end
    end

  end

  #context 'для пользователей, не являющихся разработчиками,' do
  #  it 'должен быть переход на страницу авторизации' do
  #    sign_in FactoryGirl.create(:user)
  #
  #    get :index
  #    response.should redirect_to(new_user_session_path)
  #  end
  #end

  context 'для не авторизованных пользователей' do
    it 'должен быть переход на страницу авторизации' do
      sign_out :user
      @discipline = create(:discipline)
      @checkpoint = create(:checkpoint, :control, discipline: @discipline)

      get :index, discipline_id: @discipline, checkpoint_id: @checkpoint
      response.should redirect_to(new_user_session_path)
    end
  end
end