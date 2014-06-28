class Entrance::DocumentMovement < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :from_application, class_name: 'Entrance::Application',
             foreign_key: :from_application_id

  belongs_to :to_application, class_name: 'Entrance::Application',
             foreign_key: :to_application_id

  # Совершение действий, которые указаны в этом движении.
  def apply_movement!
    if moved?
      # Необходимо перенести пакет документов из одного заявления в другое.
      from_application.packed = false
      to_application.packed = true

      if original?
        from_application.original = false
        to_application.original = true
      else
        from_application.original = false
        to_application.original = false
      end
      from_application.save!
      to_application.save!
    else
      # Доложили или забрали оригинал.
      from_application.original = original?
      from_application.save!
    end
  end
end
