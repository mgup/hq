class Entrance::ItemsController < ApplicationController
  load_and_authorize_resource :item, class: 'Entrance::CompetitiveGroupItem'

  def index ; end

  def protocols
    @type = params[:type].to_i
    @date = case @type
              when 1
                'от «7» июля 2014 г.'
              when 2
                'от «10» июля 2014 г.'
              when 3
                'от «25» июля 2014 г.'
              # when 4
              #   'от «15» июля 2014 г.'
              # when 5
              #   'от «7» июля 2014 г.'
              # when 6
              #   'от «7» июля 2014 г.'
            end
    @items = case @type
              when 1
                @items.for_7_july
              when 2
                @items.for_10_july
              when 3
                @items.for_25_july
              # when 4
              #   @items.for_15_july
              # when 5
              #   @items.for_7_july_aspirants
              # when 6
              #   @items.for_7_july_crimea
            end
    respond_to do |format|
      format.pdf
    end
  end
end
