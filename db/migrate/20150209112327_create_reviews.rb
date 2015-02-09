class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :id_r
      t.integer :number_review # номер рецензии
      t.date :date_registration # дата регистрации рецензии
      t.column :status, :integer # статус (выполнен, в процессе, просрочен)
      t.integer :appointments_id # должность!
      t.string :contract_number # номер контракта
      t.date :contract_date # дата регистрации контракта
      t.date :contract_expires # дата истечения контракта
      t.column :ordt, :integer # тип заказа (физ лицо, юр лицо)
      t.text :author # автор
      t.text :title # название
      t.integer :university_id # вуз!
      t.integer :university_auth_id # уполномоченный вуз!
      t.float :cost # стоимость рецензии
      t.float :total_cost # общая стоимость
      t.float :sheet_number # число страниц
      t.column :evaluation, :integer # отзыв на рецензию (+/-)
      t.string :auth_contract_number # номер договора уполномоченного вуза
      t.date :date_auth_university # дата отправки в уполномоченный вуз
      t.date :date_auth_contract # дата отправки контакта
      t.date :date_review # дата отправки рецензии
      t.date :date_accounting # дата отпавки бух документов
      t.column :paid, :integer # оплачено (да/нет)
      t.text :note # примечание
      t.timestamps
    end
  end
end
