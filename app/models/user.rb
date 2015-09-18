class User < ActiveRecord::Base
  include Nameable

  self.table_name = 'user'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, # :encryptable,
         :recoverable, :rememberable, :trackable, # :validatable
         authentication_keys: [:username]

  alias_attribute :id,       :user_id
  alias_attribute :username, :user_login
  alias_attribute :password, :user_password
  alias_attribute :email,    :user_email
  alias_attribute :phone,    :user_phone
  alias_attribute :active,   :user_active

  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :user_fname
  accepts_nested_attributes_for :fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :user_iname
  accepts_nested_attributes_for :iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :user_oname
  accepts_nested_attributes_for :oname

  has_many :positions, foreign_key: :acl_position_user, dependent: :destroy
  accepts_nested_attributes_for :positions, allow_destroy: true

  has_many :roles,       through: :positions
  has_many :departments, through: :positions
  
  has_many :discipline_teachers, class_name: Study::DisciplineTeacher, primary_key: :user_id, foreign_key: :teacher_id
  has_many :disciplines, through: :discipline_teachers, primary_key: :user_id

  has_many :marks, class_name: Study::Mark
  has_many :subjects, class_name: Study::Subject

  has_many :achievements
  has_many :achievement_reports

  has_many :visitor_event_dates, as: :visitor, primary_key: :id
  has_many :dates, through: :visitor_event_dates

  has_many :task_users, -> { includes(:task).references(:task).where(curator_task: {status: Curator::Task::STATUS_ACTIVE})}, class_name: Curator::TaskUser
  has_many :tasks, through: :task_users

  has_many :curator_groups, class_name: Curator::Group, foreign_key: :user_id
  has_many :groups, through: :curator_groups
  has_many :current_groups, -> { where("start_date <= '#{Date.today}' AND end_date >= '#{Date.today}'") }, class_name: Curator::Group, foreign_key: :user_id
  #has_one :current_group, through: :current_curator_group

  default_scope do
    order(:last_name_hint, :first_name_hint, :patronym_hint)
  end

  scope :with_name, -> { includes(:iname, :fname, :oname) }

  scope :by_name, -> (name) {
     joins('LEFT JOIN dictionary AS fname ON fname.dictionary_id = user_fname')
    .joins('LEFT JOIN dictionary AS iname ON iname.dictionary_id = user_iname')
    .joins('LEFT JOIN dictionary AS oname ON oname.dictionary_id = user_oname')
    .where('user_name LIKE ? OR fname.dictionary_ip LIKE ? OR iname.dictionary_ip LIKE ? OR oname.dictionary_ip LIKE ?', "%#{name}%", "%#{name}%", "%#{name}%", "%#{name}%")
  }

  scope :by_department, -> (dep_ids) {
    dep_ids = [dep_ids.id] if dep_ids.instance_of?(Department)

    joins('LEFT JOIN acl_position ON acl_position_user = user_id')
    .where("user_department IN (:ids) OR acl_position_department IN (:ids)", ids: dep_ids)
  }

  scope :in_department, -> (ids) {
    joins(:positions)
    .where('acl_position_department IN (?)', ids)
  }

  scope :with_role, -> (roles_ids) {
    joins(:positions)
    .where('acl_position_role IN (?)', roles_ids)
  }

  validates :username, presence: true
  validates :password, on: :create, presence: true
  validate :primary_position_should_be_one
  validates_associated :fname
  validates_associated :iname
  validates_associated :oname

  before_create :hash_password

  before_update :hash_password, if: :password_changed?

  def hash_password
    if self.password.blank?
      self.password = self.password_was
    else
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end

  def departments_ids
    positions.map { |p| p.department.id }
  end

  # Находит идентификаторы подразделений, в которых пользователь выполняет указанную роль.
  def departments_with_role(role)
    positions.from_role(role.to_s).map { |p| p.department }
  end

  def primary_position_should_be_one
    return true if positions.length == 0
    primaries = 0
    positions.each do |p|
      primaries += 1 if p.primary
    end
    if primaries > 1
      errors.add(:'primary',
                 'У сотрудника может быть только одна основная форма работы.')
    end
  end

  def full_name(form = :ip)
    # TODO Убрать после того, как все имена будут перенесены в словарь.
    if last_name.nil? then user_name else super(form) end
  end

  def valid_password?(password)
    if self.password.present? && self.active == true
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
      has_role = has_role || (r.name.to_sym == role) || (user_role.to_sym == role)
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

  scope :teachers, ->  {joins(:positions).where("acl_position_role IN (#{Role::ROLE_LECTURER}, #{Role::ROLE_SUBDEPARTMENT}) OR user_role IN ('lecturer', 'subdepartment')")}
  scope :curators, ->  {joins(:positions).where('acl_position_role = (?)', Role::ROLE_CURATOR)}
  scope :curators_for_today, -> {joins(:positions).where('acl_position_role = (?)', Role::ROLE_CURATOR).joins(:curator_groups).where("start_date <= '#{Date.today}' AND end_date >= '#{Date.today}'").group(:user_id)}

  scope :without, -> id {
    cond = all
    if id!=nil
      cond=cond.where('user_id != ?', id)
    else
      cond=all
    end
    cond
  }

  scope :without, -> ids { where("user_id NOT IN (#{ids.join(', ')})") }

  scope :from_name, -> name { with_name.where('dictionary.dictionary_ip LIKE :prefix OR user.user_name LIKE :prefix', prefix: "%#{name}%")}
  scope :from_department, -> department { where("#{department.split(',').collect{|d| 'acl_position.acl_position_department = ' + d.to_s}.join(' OR ')}" +
                                                                      " OR #{department.split(',').collect{|d| 'user.user_department = ' + d.to_s}.join(' OR ')}").includes(:positions).references(:positions)  }
  scope :from_subdepartment, -> subdepartment { where("#{subdepartment .split(',').collect{|d| 'acl_position.acl_position_department = ' + d.to_s}.join(' OR ')}" +
                                                    " OR #{subdepartment .split(',').collect{|d| 'user.user_subdepartment = ' + d.to_s}.join(' OR ')}").includes(:positions).references(:positions)  }
  scope :from_position, -> position { where('acl_position.acl_position_title LIKE :posprefix OR user.user_position LIKE :posprefix', posprefix: "%#{position}%")
                                      .includes(:positions).references(:positions) }
  scope :from_appointment, -> appointment { where("acl_position.appointment_id IN (#{appointment.join(',')})").includes(:positions).references(:positions) }
  scope :from_role, -> role { where("acl_position.acl_position_role = (SELECT acl_role.acl_role_id FROM acl_role WHERE acl_role.acl_role_name = '#{role}')")
  .includes(:positions).references(:positions) }


  scope :filter, -> filters {
    [:name, :department, :position].inject(all) do |cond, field|
      if filters.include?(field) && !filters[field].empty? && filters[field]
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

  def name_with_positions
    full_name+(' (' + roles.collect{|r| r.title }.join(', ') + ')')
  end

  # trigger.before(:insert) do
  #   %q(
  #        SET
  #           NEW.last_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN user ON NEW.user_fname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.first_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN user ON NEW.user_iname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.patronym_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN user ON NEW.user_oname = dictionary.dictionary_id
  #                                 LIMIT 1)
  #      )
  # end
  #
  # trigger.before(:update) do |t|
  #   t.where('NEW.user_fname <> OLD.user_fname OR NEW.user_iname <> OLD.user_iname OR
  #            NEW.user_oname <> OLD.user_oname') do
  #     %q(
  #        SET
  #           NEW.last_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN user ON NEW.user_fname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.first_name_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN user ON NEW.user_iname = dictionary.dictionary_id
  #                                 LIMIT 1),
  #           NEW.patronym_hint = (SELECT dictionary.dictionary_ip
  #                                 FROM dictionary
  #                                 JOIN user ON NEW.user_oname = dictionary.dictionary_id
  #                                 LIMIT 1)
  #      )
  #   end
  # end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end
end
