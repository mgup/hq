#require 'spec_helper'
#
#feature 'Просмотр новостей' do
#  background 'Преподаватель' do
#
#    scenario 'Просмотр списка дисциплин' do
#      discipline = create(:discipline)
#
#      visit study_discipliness_url
#
#      within 'tr' do
#        page.should have_content post.title
#      end
#      page.should have_content post.content
#    end
#
#  end
#end