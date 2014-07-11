require 'rails_helper'

describe Study::CheckpointsController, type: :controller do
  context 'для авторизованных преподавателей' do
    before do
      @user = create(:user, :lecturer)
      sign_in @user
      @discipline = create(:discipline, lead_teacher: @user)
    end

    describe 'GET #index' do
      context 'при отсутствии у дисциплины контрольных точек' do
        it 'должен перейти на страницу с контрольными точками' do
          get :index, discipline_id: @discipline
          expect(response).to redirect_to(
            new_study_discipline_checkpoint_path(@discipline)
          )
        end
      end

      context 'при наличии у дисциплины контрольных точек' do
        before :each do
          @discipline.classes << create(:checkpoint, :control,
                                        discipline: @discipline)
          @checkpoint = create(:checkpoint, discipline: @discipline)
          get :index, discipline_id: @discipline
        end

        it 'должен выполняться успешно' do
          expect(response).to be_success
        end

        it 'должен выводить правильное представление' do
          expect(response).to render_template(:index)
        end

        it 'должен содержать тестовую точку' do
          expect(assigns(:classes)).to include(@checkpoint)
        end
      end
    end

    describe 'GET #new' do
      before :each do
        get :new, discipline_id: @discipline
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:new)
      end

      it 'должна генерироваться форма для дисциплины' do
        expect(assigns(:discipline)).to eq(@discipline)
      end

    end
  end
end
