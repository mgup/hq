class User < ActiveRecord::Base
  self.table_name = 'user'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, # :validatable,
         authentication_keys: [:username]

  alias_attribute :username, :user_login
  alias_attribute :password, :user_password
  alias_attribute :email,    :user_email
  alias_attribute :phone,    :user_phone

  has_one :fname, class_name: Dictionary, primary_key: :user_fname, foreign_key: :dictionary_id
  has_one :iname, class_name: Dictionary, primary_key: :user_iname, foreign_key: :dictionary_id
  has_one :oname, class_name: Dictionary, primary_key: :user_oname, foreign_key: :dictionary_id

  %w(last_name first_name patronym).each do |name|
    %w(ip rp dp vp tp pp).each do |part|
      define_method("#{name}_#{part}") do
        send(name, part.to_sym)
      end
    end
  end

  # Фамилия человека в определённом падеже (ip, rp, dp, vp, tp, pp).
  #
  # Если у человека не известна или не заполнена фамилия в указанном падеже —
  # возвращаем именительный падеж.
  def last_name(form = :ip)
    fname.send(form) unless fname.nil?
  end

  # Имя человека в определённом падеже (ip, rp, dp, vp, tp, pp).
  #
  # Если у человека не известно или не заполнено имя в указанном падеже —
  # возвращаем именительный падеж.
  def first_name(form = :ip)
    iname.send(form) unless iname.nil?
  end

  # Отчество человека в определённом падеже (ip, rp, dp, vp, tp, pp).
  #
  # Если у человека не известно или не заполнено отчество в указанном падеже —
  # возвращаем именительный падеж.
  def patronym(form = :ip)
    oname.send(form) unless oname.nil?
  end

  # Полное имя человека в формате «Иванов Иван Иванович» в определённом падеже
  # (ip, rp, dp, vp, tp, pp).
  def full_name(form = :ip)
    if last_name.nil?
      # TODO Убрать после того, как все имена будут переведены на новую схему.
      user_name
    else
      [last_name(form), first_name(form), patronym(form)].reject(&:nil?).join(' ')
    end
  end

  # Сокращённое имя человека в формате «Иванов И. И.» в определённом падеже
  # (ip, rp, dp, vp, tp, pp). Употребляется при алфавитном перечислении имён
  # либо в «менее официальных» документах.
  def short_name(form = :ip)
    result = last_name(form) + ' ' + first_name(form)[0, 1] + '.'
    result += ' ' + patronym(form)[0, 1] + '.' unless patronym(form).nil?
    result
  end

  # Сокращённое имя человека в формате «И. И. Иванов» в определённом падеже
  # (ip, rp, dp, vp, tp, pp). Употребляется в официальных (персонализированных)
  # документах.
  def short_name_official(form = :ip)
    result = first_name(form)[0, 1] + '. '
    result += patronym(form)[0, 1] + '. ' unless patronym(form).nil?
    result + last_name(form)
  end

  def valid_password?(password)
    if self.password.present?
      if ::Digest::MD5.hexdigest(password) == self.user_password
        # self.password = password
        # self.client_password = nil
        # self.save!

        true
      else
        false
      end
    else
      super
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(['lower(user_login) = :username', { :username => username.downcase }]).first
    else
      where(conditions).first
    end
  end
end
