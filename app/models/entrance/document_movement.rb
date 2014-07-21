class Entrance::DocumentMovement < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :from_application, class_name: 'Entrance::Application',
             foreign_key: :from_application_id

  belongs_to :to_application, class_name: 'Entrance::Application',
             foreign_key: :to_application_id

  default_scope do
    order(created_at: :desc)
  end

  scope :for_applications, -> (applications) do
    where(from_application_id: applications.map(&:id))
  end

  delegate :entrant, to: :from_application

  # Совершение действий, которые указаны в этом движении.
  def apply_movement!
    if moved?
      if to_application
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
        moved = false
        save!
      end
    else
      # Доложили или забрали оригинал.
      from_application.original = original?
      from_application.save!
    end
  end

  def description
    d = []

    if moved?
      with_original = original? ? '+' : '-'
      d << "Комплект (#{with_original}) перенесён в #{to_application.number}."
    end

    if original_changed
      if original?
        d << 'Принесён оригинал аттестата.'
      else
        d << 'Забран оригинал аттестата.'
      end
    end

    d.join(' ')
  end
end
