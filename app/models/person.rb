class Person < ActiveRecord::Base
  include Nameable

  MALE = true
  FEMALE = false

  # Статус по общежитию
  HOSTEL_STATUS_NOT = 1 # Отказано в заселении или не проживает в общежитии
  HOSTEL_STATUS_RECOMMEND = 2 # Рекомендован к заселению
  HOSTEL_STATUS_ACCEPT = 3 # Человек проживает в общежитии
  HOSTEL_STATUS_EVICTSELF = 4 # Человек выселен по собственному желанию
  # Нужны ли сейчас последние два статуса
  HOSTEL_STATUS_NEO = 5 # для разных форм
  HOSTEL_STATUS_NEO_ACCEPT = 6 # заселен для разных форм

  # Льготы
   BENEFITS_FREE = 1 # Льгот нет
   BENEFITS_ORPHAN = 2 # Сирота
   BENEFITS_DISABLEDCHILDREN  = 3 # Дети-инвалиды
   BENEFITS_DISABLED1AND2 = 4 # Инвалид 1-2 группы
   BENEFITS_DISABLED3 = 5 # Инвалид 3 группы
   BENEFITS_DISABLEDCHILDREN3 = 6 # 3 группа инвалид с детства
   BENEFITS_ARMY = 7 # Инвалиды и ветераны боевых действий
   BENEFITS_RADIATION = 8 # Радиационные катастрофы (ЧАЭС)
   BENEFITS_POOR = 9 # Малоимущие
   BENEFITS_OTHER = 10 # Другие льготы

  # Воинская обязанность
   ARMY_NOT_RESERVIST = 0
   ARMY_INDUCTEE = 1
   ARMY_RESERVIST = 2
   ARMY_SOLDIER = 3
   ARMY_OTHER = 4


  self.table_name = 'student'

  alias_attribute :id,                       :student_id
  alias_attribute :birthday,                 :student_birthday
  alias_attribute :birthplace,               :student_birthplace
  alias_attribute :gender,                   :student_gender
  alias_attribute :foreign,                  :student_foreign
  alias_attribute :homeless,                 :student_homeless
  alias_attribute :passport_series,          :student_pseries
  alias_attribute :passport_number,          :student_pnumber
  alias_attribute :passport_date,            :student_pdate
  alias_attribute :passport_department,      :student_pdepartment
  alias_attribute :passport_department_code, :student_pcode
  alias_attribute :passport_code,            :student_pcode
  alias_attribute :registration_address,     :student_registration_address
  alias_attribute :registration_zip,         :student_registration_zip
  alias_attribute :residence_address,        :student_residence_address
  alias_attribute :residence_zip,            :student_residence_zip
  alias_attribute :phone_home,               :student_phone_home
  alias_attribute :email,                    :student_email
  alias_attribute :phone_mobile,             :student_phone_mobile
  alias_attribute :benefits,                 :student_benefits
  alias_attribute :army,                     :student_army
  alias_attribute :army_voenkom,             :student_army_voenkom
  alias_attribute :hostel_st,                :student_hostel_status


  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_fname, dependent: :destroy
  accepts_nested_attributes_for :fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_iname, dependent: :destroy
  accepts_nested_attributes_for :iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_oname, dependent: :destroy
  accepts_nested_attributes_for :oname

  belongs_to :room, class_name: Hostel::Room, primary_key: :room_id,
           foreign_key: :student_room

  has_many :students, primary_key: :student_id, foreign_key: :student_group_student, dependent: :destroy
  accepts_nested_attributes_for :students

  has_many :deeds, class_name: 'Social::Document', foreign_key: :student_id, primary_key: :student_id
  has_many :archive_persons, class_name: 'Archive::Person', foreign_key: :student_id, primary_key: :student_id

  scope :from_flat, -> flat { joins(:room).where(room: {room_flat: flat})}

  scope :by_name, -> (name) {
    joins('LEFT JOIN dictionary AS fname ON fname.dictionary_id = student_fname')
    .joins('LEFT JOIN dictionary AS iname ON iname.dictionary_id = student_iname')
    .joins('LEFT JOIN dictionary AS oname ON oname.dictionary_id = student_oname')
    .where('last_name_hint LIKE ? OR first_name_hint LIKE ? OR patronym_hint LIKE ? OR fname.dictionary_ip LIKE ? OR iname.dictionary_ip LIKE ? OR oname.dictionary_ip LIKE ?', "%#{name}%", "%#{name}%", "%#{name}%", "%#{name}%", "%#{name}%", "%#{name}%")
  }

  def male?
    MALE == gender
  end

  def female?
    FEMALE == gender
  end

  def sex
    case gender
      when MALE
        'мужской'
      when FEMALE
        'женский'
    end
  end

  def hostel
    room.flat.hostel
  end

  def benefits_free?
    BENEFITS_FREE == benefits
  end

  def hostel_status
    case student_hostel_status
      when HOSTEL_STATUS_NOT
        {status: 'Студент не проживает в общежитии', short: 'не заселён'}
      when HOSTEL_STATUS_RECOMMEND
        {status: 'Студент рекомендован к заселению в общежитие', short: 'рекомендован'}
      when HOSTEL_STATUS_ACCEPT
        {status: 'Студент проживает в общежитии', short: 'заселён'}
      when HOSTEL_STATUS_EVICTSELF
        {status: 'Студент выселился из общежития по собственному желанию', short: 'выселился'}
      when HOSTEL_STATUS_NEO
        {status: 'Студент рекомендован к заселению (другие формы)', short: 'рекомендован'}
      when HOSTEL_STATUS_NEO_ACCEPT
        {status: 'Студент проживает в общежитии (другие формы)', short: 'заселён'}
    end
  end

  def benefits_type
    case benefits
      when BENEFITS_FREE
        'льгот нет'
      when BENEFITS_ORPHAN
        'сирота'
      when BENEFITS_DISABLEDCHILDREN
        'дети-инвалиды'
      when BENEFITS_DISABLED1AND2
        'инвалид 1-2 группы'
      when BENEFITS_DISABLED3
        'инвалид 3 группы'
      when BENEFITS_DISABLEDCHILDREN3
        '3 группа инвалид с детства'
      when BENEFITS_ARMY
        'инвалиды и ветераны боевых действий'
      when BENEFITS_RADIATION
        'радиационные катастрофы (ЧАЭС)'
      when BENEFITS_POOR
        'малоимущие'
      when BENEFITS_OTHER
        'другие льготы'
    end
  end

  def army_status
    case army
      when ARMY_NOT_RESERVIST
        'невоеннообязанный'
      when ARMY_INDUCTEE
        'призывник'
      when ARMY_RESERVIST
        'в запасе'
      when ARMY_SOLDIER
        'военнослужащий'
      when ARMY_OTHER
        'неизвестно'
    end
  end

  # trigger.before(:insert) do
  #   %q(
  #        SET
  #           NEW.last_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN student ON NEW.student_fname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.first_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN student ON NEW.student_iname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.patronym_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN student ON NEW.student_oname = dictionary.dictionary_id
  #                                 LIMIT 1)
  #      )
  # end
  #
  # trigger.before(:update) do |t|
  #   t.where('NEW.student_fname <> OLD.student_fname OR NEW.student_iname <> OLD.student_iname OR
  #            NEW.student_oname <> OLD.student_oname') do
  #     %q(
  #        SET
  #           NEW.last_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN student ON NEW.student_fname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.first_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN student ON NEW.student_iname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.patronym_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN student ON NEW.student_oname = dictionary.dictionary_id
  #                                 LIMIT 1)
  #      )
  #   end
  # end


  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.person {
        xml.id_   student_id
        xml.hostel hostel.address if student_room
        xml.foreign student_foreign if student_foreign
        name_to_nokogiri.children[0].children.each { |part| xml << part.to_xml }
      }
    }.doc
  end

  delegate :to_xml, to: :to_nokogiri
end