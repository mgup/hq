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
      физ_лицо: 0,
      юр_лицо: 1
  }
  enum evaluation: {    # тип отзыва на рецензию
      '+' => 0,
      '-' => 1,
      undefined: 2
  }
  enum paid: {    # оплата
      оплачено: 0,
      'нет оплаты' => 1
  }

end