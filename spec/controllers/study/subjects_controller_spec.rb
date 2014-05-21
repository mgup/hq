require 'spec_helper'

describe Study::SubjectsController do 
	before do
  		@group = FactoryGirl.create(:group)
  		@subject = FactoryGirl.create(:subject, group: @group)
	end

 	describe 'GET "index"' do
    	before :each do
      		get :index, group_id: @group.id
    	end
    	it 'должен выполняться успешно' do
      		response.should be_success
    	end

    	it 'должен выводить правильное представление' do
      		response.should render_template(:index)
    	end

  	end




	end