class Entrance::ExamResultsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :entrant, throught: :campaign,
                              class: 'Entrance::Entrant'
  load_and_authorize_resource through: :entrant, class: 'Entrance::ExamResult'

  def index

  end
end