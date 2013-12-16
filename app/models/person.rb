class Person < ActiveRecord::Base
  include Nameable

  MALE = true
  FEMALE = false

  self.table_name = 'student'

  alias_attribute :id, :student_id
  alias_attribute :birthday, :student_birthday
  alias_attribute :birthplace, :student_birthplace
  alias_attribute :gender, :student_gender
  alias_attribute :homeless, :student_homeless
  alias_attribute :passport_series,     :student_pseries
  alias_attribute :passport_number,     :student_pnumber
  alias_attribute :passport_date,       :student_pdate
  alias_attribute :passport_department, :student_pdepartment
  alias_attribute :passport_department_code, :student_pcode
  alias_attribute :registration_address, :student_registration_address
  alias_attribute :registration_zip, :student_registration_zip
  alias_attribute :residence_address, :student_residence_address
  alias_attribute :residence_zip, :student_residence_zip
  alias_attribute :phone_home, :student_phone_home
  alias_attribute :email, :student_email
  alias_attribute :phone_mobile, :student_phone_mobile
  alias_attribute :benefits, :student_benefits
  alias_attribute :army, :student_army
  alias_attribute :army_voenkom, :student_army_voenkom


  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_oname

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

  def army_status
    case army
      when 0
        'невоеннообязанный'
      when 1
        'призывник'
      when 2
        'в запасе'
      when 3
        'военнослужащий'
      when 4
        'неизвестно'
    end
  end

  trigger.before(:insert) do
    %q(
         SET
            NEW.last_name_hint = (SELECT dictionary.dictionary_ip
                                  FROM dictionary
                                  JOIN student ON NEW.student_fname = dictionary.dictionary_id
                                  LIMIT 1),
            NEW.first_name_hint = (SELECT dictionary.dictionary_ip
                                  FROM dictionary
                                  JOIN student ON NEW.student_iname = dictionary.dictionary_id
                                  LIMIT 1),
            NEW.patronym_hint = (SELECT dictionary.dictionary_ip
                                  FROM dictionary
                                  JOIN student ON NEW.student_oname = dictionary.dictionary_id
                                  LIMIT 1)
       )
  end

  trigger.before(:update) do |t|
    t.where('NEW.student_fname <> OLD.student_fname OR NEW.student_iname <> OLD.student_iname OR
             NEW.student_oname <> OLD.student_oname') do
      %q(
         SET
            NEW.last_name_hint = (SELECT dictionary.dictionary_ip
                                  FROM dictionary
                                  JOIN student ON NEW.student_fname = dictionary.dictionary_id
                                  LIMIT 1),
            NEW.first_name_hint = (SELECT dictionary.dictionary_ip
                                  FROM dictionary
                                  JOIN student ON NEW.student_iname = dictionary.dictionary_id
                                  LIMIT 1),
            NEW.patronym_hint = (SELECT dictionary.dictionary_ip
                                  FROM dictionary
                                  JOIN student ON NEW.student_oname = dictionary.dictionary_id
                                  LIMIT 1)
       )
    end
  end


  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.person {
        xml.id_   id
        %w(last_name first_name patronym).each do |name|
          xml.send(name) {
            %w(ip rp dp vp tp pp).each do |form|
              xml.send("#{form}_", self.send(name, form.to_sym))
            end
          }
        end
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end