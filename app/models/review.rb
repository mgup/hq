class Review < ActiveRecord::Base
  belongs_to :appointment # связь с должностями
  belongs_to :university, foreign_key: :university_id
  belongs_to :university_author, class: University, foreign_key: :university_auth_id

  enum status: {    # статус рецензии
      обработка: 0,
      завершен: 1,
      истек: 2
  }
  enum ordt: {    # тип заказа
      физ: 0,
      юр: 1
  }
  enum evaluation: {    # тип отзыва на рецензию
      '+' => 0,
      '-' => 1,
      неопр: 2
  }
  enum paid: {    # оплата
      да: 0,
      нет: 1
  }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |review|
        csv << review.attributes.values_at(*column_names)
      end
    end
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

end