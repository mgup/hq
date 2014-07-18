class Entrance::Entrant < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  enum gender: { male: 1, female: 2 }
  enum citizenship: { russian: 1, other_citizenship: 2 }
  enum acountry: { russia: 0, cis: 1, other_countries: 2 }
  enum military_service: { not: 1, conscript: 2, reservist: 6,
                           free_of_service: 7, too_young: 8 }
  enum foreign_language: { english: 24, german: 12, french: 13, spanish: 14 }

  belongs_to :identity_document_type
  belongs_to :nationality_type

  belongs_to :campaign, class_name: Entrance::Campaign

  has_many :exam_results, class_name: 'Entrance::ExamResult', dependent: :destroy
  accepts_nested_attributes_for :exam_results, allow_destroy: true

  has_one :edu_document, class_name: 'Entrance::EduDocument', dependent: :destroy
  accepts_nested_attributes_for :edu_document, update_only: true

  has_many :papers, class_name: 'Entrance::Paper', foreign_key: :entrance_entrant_id, dependent: :destroy
  accepts_nested_attributes_for :papers, allow_destroy: true

  has_many :checks, class_name: 'Entrance::UseCheck', foreign_key: :entrant_id, dependent: :destroy

  has_many :applications, class_name: Entrance::Application, dependent: :destroy
  accepts_nested_attributes_for :applications, allow_destroy: true
  has_many :contracts, through: :applications, class_name: 'Entrance::Contract'

  has_one :packed_application, -> { where('packed = 1') },
          class_name: Entrance::Application

  has_many :event_entrants, class_name: Entrance::EventEntrant, foreign_key: :entrance_entrant_id
  accepts_nested_attributes_for :event_entrants, allow_destroy: true
  has_many :events, class_name: Entrance::Event, through: :event_entrants

  scope :aspirants, -> { joins(:edu_document).where('entrance_edu_documents.direction_id IS NOT NULL') }
  scope :from_exam, -> exam_id { joins(:exam_results).where('entrance_exam_results.exam_id = ? AND entrance_exam_results.form = 2', exam_id) }

  scope :from_pseries, -> pseries { where(pseries: pseries) }
  scope :from_pnumber, -> pnumber { where(pnumber: pnumber) }
  scope :from_last_name, -> last_name { where(last_name: last_name) }

  scope :without_checks, -> {includes(:checks).where(entrance_use_checks: {entrant_id: nil} )}

  scope :filter, -> filters {
    [:pseries, :pnumber, :last_name].inject(all) do |cond, field|
      if filters.include?(field) && !filters[field].empty?
        cond = cond.send "from_#{field.to_s}", filters[field]
      end
      cond
    end
  }

  scope :from_direction, -> direction_id { joins(:applications)
                                  .where("entrance_applications.competitive_group_item_id IN (#{Entrance::CompetitiveGroupItem.from_direction(direction_id).collect{|x| x.id}.join(', ')})")
                                  .select('DISTINCT entrance_entrants.id, entrance_entrants.last_name, entrance_entrants.first_name, entrance_entrants.patronym') }

  before_create do |entrant|
    entrant.build_edu_document
  end

  after_create do |entrant|
    Entrance::Log.create entrant_id: entrant.id, user_id: User.current.id,
                         comment: 'Добавлена информация об абитуриенте.'
  end

  after_update do |entrant|
    Entrance::Log.create entrant_id: entrant.id, user_id: User.current.id,
                         comment: 'Обновлена информация об абитуриенте.'
  end

  default_scope do
    order(:last_name, :first_name, :patronym)
  end

  # def patronym
  #   res = super
  #   res.blank? ? ' ' : res
  # end

  def full_name
    [last_name, first_name, patronym].join(' ')
  end

  def short_name
    if patronym.blank?
      "#{last_name} #{first_name[0]}."
    else
      "#{last_name} #{[first_name[0] + '.', patronym[0] + '.'].join(' ')}"
    end
  end

  def citizen_name
    case citizenship
      when 'russian'
        'Российская Федерация'
      else
        'зарубежье'
    end
  end

  def self.as_csv
    CSV.generate do |csv|
      all.each do |e|
        csv << ["#{e.last_name}%#{e.first_name}%#{e.patronym}%#{e.pseries}%#{e.pnumber}".encode('windows-1251')]
      end
    end
  end

  def military_status
    case military_service
      when 'not'
        'невоеннообязанный'
      when 'conscript'
        'призывник'
      when 'reservist'
        'военнообязанный'
      when 'free_of_service'
        'освобождён от воинской обязанности'
      when 'too_young'
        'не достигший возраста призывника'
    end
  end

  def contacts
    [azip, aaddress, phone].join(', ')
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.entrant {
        xml.id_   id
        xml << packed_application.to_nokogiri.root.to_xml
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end
