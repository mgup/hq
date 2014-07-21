class Entrance::Date < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: 'Entrance::Campaign'
  belongs_to :education_form
  belongs_to :education_type
  belongs_to :education_source

  default_scope do
    order(:start_date, :end_date, :order_date)
  end

  def description
    Unicode::capitalize([education_form.name,
                         education_type.name,
                         education_source.name].join(', '))
  end
end
