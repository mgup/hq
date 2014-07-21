require 'rails_helper'

describe Study::StudentsController, type: :controller do
  before  do
    @group = FactoryGirl.create(:group)
    @student = FactoryGirl.create(
      :student,
      person: FactoryGirl.create(
        :person, fname: FactoryGirl.create(:dictionary),
                 iname: FactoryGirl.create(:dictionary),
                 oname: FactoryGirl.create(:dictionary)
      ),
      group: @group)
  end

  describe 'GET #show' do
    before :each do
      get :show, group_id: @group.id, id: @student.id
    end

    it 'должен выполняться успешно' do
      expect(response).to be_success
    end

    it 'должен выводить правильное представление' do
      expect(response).to render_template(:show)
    end

    it 'должен находить правильного студента' do
      expect(assigns(:student)).to eql(@student)
    end

  end

  describe 'GET #discipline' do
    before :each do
      user = FactoryGirl.create(:user)
      @discipline = FactoryGirl.create(:discipline, lead_teacher: user,
                                                    group: @group)
      get :discipline, group_id: @group.id,
                       id: @student.id,
                       discipline: @discipline.id
    end

    it 'должен выполняться успешно' do
      expect(response).to be_success
    end

    it 'должен выводить правильное представление' do
      expect(response).to render_template(:discipline)
    end
  end
end
