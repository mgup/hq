class User < ActiveRecord::Base
  self.table_name = 'user'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:username]

  alias_attribute :username, :user_login
  alias_attribute :password, :user_password
  alias_attribute :email,    :user_email

  def valid_password?(password)
    if self.password.present?
      if ::Digest::MD5.hexdigest(password) == self.user_password
        # После окончательного перехода на новую систему следующую строку нужно
        # удалить, а вторую раскомментировать, чтобы перейти на более сильную
        # защиту паролей пользователей.
        # self.password = password
        #self.client_password = nil

        self.save!
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
