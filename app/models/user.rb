class User < ActiveRecord::Base
  include Nameable

  self.table_name = 'user'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, # :validatable,
         authentication_keys: [:username]

  alias_attribute :id,       :user_id
  alias_attribute :username, :user_login
  alias_attribute :password, :user_password
  alias_attribute :email,    :user_email
  alias_attribute :phone,    :user_phone

  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :user_fname
  accepts_nested_attributes_for :fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :user_iname
  accepts_nested_attributes_for :iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :user_oname
  accepts_nested_attributes_for :oname

  has_many :positions, foreign_key: :acl_position_user, dependent: :destroy
  accepts_nested_attributes_for :positions, allow_destroy: true , reject_if: proc { |attrs| attrs[:title].blank? }
  has_many :roles,       through: :positions
  has_many :departments, through: :positions
  
  has_many :discipline_teachers, class_name: Study::DisciplineTeacher, primary_key: :user_id, foreign_key: :teacher_id
  has_many :disciplines, :through => :discipline_teachers, primary_key: :user_id

  has_many :marks, class_name: Study::Mark
  has_many :subjects, class_name: Study::Subject

  scope :with_name, -> { includes(:iname, :fname, :oname) }

  validates :username, presence: true
  validates :password, presence: true
  validates_associated :fname
  validates_associated :iname
  validates_associated :oname

  def full_name(form = :ip)
    # TODO Убрать после того, как все имена будут перенесены в словарь.
    if last_name.nil? then user_name else super(form) end
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

  def is?(role)
    roles.inject(false) do |has_role, r|
      has_role = has_role || (r.name.to_sym == role)
      has_role
    end
  end

  def add_object_link(name, form, object, partial, where)
    options = {:parent => true}.merge(options)
    html = render(:partial => partial, :locals => { :form => form}, :object => object)
    link_to_function name, %{
    var new_object_id = new Date().getTime() ;
    var html = jQuery(#{js html}.replace(/index_to_replace_with_js/g, new_object_id)).hide();
    html.appendTo(jQuery("#{where}")).slideDown('slow');
  }
  end

  scope :teachers, ->  {where(user_role: 'lecturer')}

  scope :without, -> id {
    cond = all
    if id!=nil
      cond=cond.where('user_id != ?', id)
    else
      cond=all
    end
    cond
  }

  scope :from_name, -> name { with_name.where('dictionary.dictionary_ip LIKE :prefix OR user.user_name LIKE :prefix', prefix: "%#{name}%")}
  scope :from_department, -> department { where("#{department.collect{|d| 'acl_position.acl_position_department = ' + d.to_s}.join(' OR ')}" +
                                                                      " OR #{department.collect{|d| 'user.user_department = ' + d.to_s}.join(' OR ')}").includes(:positions)  }
  scope :from_position, -> position { where('acl_position.acl_position_title LIKE :posprefix OR user.user_position LIKE :posprefix', posprefix: "%#{position}%")
                                      .includes(:positions) }


  scope :filter, -> filters {
    [:name, :department, :position].inject(all) do |cond, field|
      if filters.include?(field) && !filters[field].empty?
        cond = cond.send "from_#{field.to_s}", filters[field]
      end
      cond
    end
  }

  #before_save :get_positions
  #
  #def get_positions
  #  self.positions = self.positions.collect do |position|
  #    Position.find_or_create_by_position_id(position.id)
  #  end
  #end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(['lower(user_login) = :username', { username: username.downcase }]).first
    else
      where(conditions).first
    end
  end

end
