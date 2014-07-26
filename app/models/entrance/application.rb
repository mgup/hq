class Entrance::Application < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: 'Entrance::Campaign'
  belongs_to :entrant, class_name: 'Entrance::Entrant'
  belongs_to :competitive_group_item, class_name: 'Entrance::CompetitiveGroupItem'

  delegate :direction, to: :competitive_group_item
  delegate :department, to: :direction
  delegate :form, to: :competitive_group_item
  delegate :competitive_group, to: :competitive_group_item
  delegate :payed?, to: :competitive_group_item

  has_many :benefits, class_name: 'Entrance::Benefit'

  has_one :contract, class_name: 'Entrance::Contract'

  after_create do |application|
    Entrance::Log.create entrant_id: application.entrant.id,
                         user_id: User.current.id,
                         comment: "Создано заявление #{application.id}."
  end

  after_update do |application|
    Entrance::Log.create entrant_id: application.entrant.id,
                         user_id: User.current.id,
                         comment: "Обновлено заявление #{[application.number, application.id].join(', ')}."
  end

  # default_scope do
  #   where('status_id != ?', 6)
  # end

  scope :actual, -> { where('status_id != ?', 6) }

  scope :without_called_back, -> do
    where('status_id != ?', 6)
  end

  scope :from_aspirant, -> do
    joins(:competitive_group_item).where('competitive_group_items.direction_id IN (?)', Direction.for_aspirants.collect{|x| x.id}.join(', '))
  end

  scope :for_direction, -> (direction) do
    joins(:competitive_group_item).
      where('competitive_group_items.direction_id = ?', direction.id)
  end

  scope :paid, -> do
    where('number_paid_o > 0 OR number_paid_oz > 0 OR number_paid_z > 0').
    where('number_budget_o = 0 AND number_budget_oz = 0 AND number_budget_z = 0').
    where('number_quota_o = 0 AND number_quota_oz = 0 AND number_quota_z = 0')
  end

  scope :not_paid, -> do
    where('number_paid_o = 0 AND number_paid_oz = 0 AND number_paid_z = 0')
  end

  scope :o_form, -> do
    where('number_budget_o > 0 OR number_paid_o > 0 OR number_quota_o > 0')
  end

  scope :oz_form, -> do
    where('number_budget_oz > 0 OR number_paid_oz > 0 OR number_quota_oz > 0')
  end

  scope :z_form, -> do
    where('number_budget_z > 0 OR number_paid_z > 0 OR number_quota_z > 0')
  end

  scope :for_rating, -> do
    select('CASE b.benefit_kind_id WHEN 1 THEN 1 WHEN 4 THEN 4 ELSE NULL END AS benefit_type')
    .select('COALESCE(SUM(r.score), 0) AS total_score')
    .select('MIN(r.score >= ti.min_score) AS pass_min_score')
    .select('pr.score AS priority_score')
    .select('entrance_applications.*')
    .joins('LEFT JOIN entrance_benefits AS b ON b.application_id = entrance_applications.id')
    .joins('LEFT JOIN competitive_group_items AS i ON i.id = entrance_applications.competitive_group_item_id')
    .joins('LEFT JOIN competitive_groups AS g ON g.id = i.competitive_group_id')
    .joins('LEFT JOIN entrance_test_items AS ti ON ti.competitive_group_id = g.id')
    .joins('LEFT JOIN entrance_exam_results AS r ON r.entrant_id = entrance_applications.entrant_id AND ti.exam_id = r.exam_id')
    .joins('LEFT JOIN entrance_exam_results AS pr ON pr.entrant_id = entrance_applications.entrant_id AND ti.exam_id = pr.exam_id AND ti.entrance_test_priority = 1')
    .joins('LEFT JOIN directions AS d ON d.id = i.direction_id')
    .where('status_id != 6')
    .group('entrance_applications.id')
    .order('benefit_type = 1 DESC')
	  .order('benefit_type = 4 DESC')
    .order('total_score DESC')
    .order('priority_score DESC')
  end

  def abitpoints
    sum = 0
    competitive_group_item.competitive_group.test_items.collect{|x| x.exam}.each do |exam|
      sum += entrant.exam_results.by_exam(exam.id).last.score if entrant.exam_results.by_exam(exam.id).last.score
    end
    sum
  end

  def abitexams
    exams = []
    competitive_group_item.competitive_group.test_items.order(:entrance_test_priority).collect{|x| x.exam}.each do |exam|
      exams << entrant.exam_results.by_exam(exam.id).last
    end
    exams
  end

  def self.rating(form = '11', payment = '14', direction = '1887')
    form_method = case form
                    when '10'
                      :z_form
                    when '12'
                      :oz_form
                    else
                      :o_form
                  end
    payment_method = case payment
                       when '15'
                         :paid
                       else
                         :not_paid
                     end

    applications = self.for_rating.
        where('d.id = ?', direction).
        send(form_method).send(payment_method)
    return applications
  end

  def self.direction_stats(campaign, direction)
    applications = campaign.applications.for_direction(direction)

    stats = {}
    [:budget, :paid].each do |payment|
      stats[payment] = {}
      [:o, :oz, :z].each do |form|
        stats[payment][form] = { total: 0, original: 0 }
      end
    end

    applications.each do |app|
      form = case app.competitive_group_item.form
        when 11
          :o
        when 12
          :oz
        when 10
          :z
      end

      payment_form = app.competitive_group_item.payed? ? :paid : :budget

      stats[payment_form][form][:total] += 1
      stats[payment_form][form][:original] += 1 if app.original?
    end

    stats
  end

  def entrance_type(full_name = true)
    benefit = benefits.first
    if benefit
      # if benefit.benefit_kind.out_of_competition?
      #   return benefits.first.benefit_kind.short_name
      # end
      # if benefit.benefit_kind.special_rights?
      #   return benefits.first.benefit_kind.short_name
      # end

      if full_name
        return benefits.first.benefit_kind.name
      else
        return benefits.first.benefit_kind.short_name
      end
    end

    use = true
    entrant.exam_results.in_competitive_group(competitive_group_item.competitive_group).each do |exam_result|
      use = false if exam_result.university?
    end

    use ? 'ЕГЭ' : 'ВИ'
  end

  def out_of_competition
    if benefits && benefits.first
      benefits.first.benefit_kind.out_of_competition?
    end

    false
  end

  # def total_score
  #   results = entrant.exam_results.in_competitive_group(competitive_group)
  #   results.inject(0) do |result, exam|
  #     exam.score ? result + exam.score : result
  #   end
  # end

  def self.register_information
    applications = []
    self.all.each_with_index do |application, index|
      applications << [index + 1, (I18n.l application.created_at, format: '%d.%m.%Y'), application.entrant.full_name, application.number, application.entrant.contacts, '']
    end
    return applications
  end

  def self.report_information(campaign)
    Department.faculties.map do |faculty|
      applications = faculty.directions.for_campaign(campaign).map do |direction|
        stats = self.direction_stats(campaign, direction)

        row = [direction.description]

        [:budget, :paid].each do |p|
          [:o, :oz, :z].each do |f|
            row << if stats[p][f][:total].zero?
                     ''
                   else
                     "#{stats[p][f][:total]} (#{stats[p][f][:original]})"
                   end
          end
        end

        row
      end

      { faculty: faculty.name, applications: applications }
    end
  end

  def called_back?
    6 == status_id
  end

  # Внесение абитуриента из заявления в список студентов.
  def enroll
    group = find_group(competitive_group_item, entrant.ioo)
    if group.is_a?(Hash)
      fail "Не найдена группа со следующими характеристиками: код направления подготовки (специальности): #{group[:speciality]}, форма обучения: #{group[:form]}"
    else
      army = case entrant.military_service
               when 'not'
                 Person::ARMY_NOT_RESERVIST
               when 'conscript'
                 Person::ARMY_INDUCTEE
               when 'reservist'
                 Person::ARMY_RESERVIST
               when 'free_of_service'
                 Person::ARMY_NOT_RESERVIST
               when 'too_young'
                 Person::ARMY_NOT_RESERVIST
             end

      Person.create!(
        birthday: entrant.birthday,
        birthplace: entrant.birth_place,
        gender: entrant.male?,
        homeless: entrant.need_hostel,
        passport_series: entrant.pseries,
        passport_number: entrant.pnumber,
        passport_date: entrant.pdate,
        passport_department: entrant.pdepartment,
        phone_mobile: entrant.phone,
        residence_address: entrant.aaddress,
        residence_zip: entrant.azip,
        student_foreign: entrant.other_citizenship?,
        army: army,
        last_name_hint: entrant.last_name,
        first_name_hint: entrant.first_name,
        patronym_hint: entrant.patronym,
        student_oldid: 0,
        student_oldperson: 0,
        fname_attributes: {
          ip: entrant.last_name,
          rp: entrant.last_name,
          dp: entrant.last_name,
          vp: entrant.last_name,
          tp: entrant.last_name,
          pp: entrant.last_name
        },
        iname_attributes: {
          ip: entrant.first_name,
          rp: entrant.first_name,
          dp: entrant.first_name,
          vp: entrant.first_name,
          tp: entrant.first_name,
          pp: entrant.first_name
        },
        oname_attributes: {
          ip: entrant.patronym,
          rp: entrant.patronym,
          dp: entrant.patronym,
          vp: entrant.patronym,
          tp: entrant.patronym,
          pp: entrant.patronym
        },
        students_attributes: {
          '0' => {
            student_group_group: group.id,
            student_group_yearin: Date.today.year,
            student_group_tax:  payed? ? Student::PAYMENT_OFF_BUDGET : Student::PAYMENT_BUDGET,
            student_group_status: Student::STATUS_ENTRANT,
            student_group_speciality: group.speciality.id,
            student_group_form: group.form,
            student_group_oldgroup: 0,
            student_group_oldstudent: 0,
            entrant_id: entrant.id
          }
        }
      )
    end
  end

  def to_fis
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Application do
        xml.UID               id
        xml.ApplicationNumber number
        xml.Entrant do
          xml.UID         entrant.id
          xml.FirstName   entrant.first_name
          xml.MiddleName  entrant.patronym
          xml.LastName    entrant.last_name
          xml.GenderID    entrant[:gender]
        end
        xml.RegistrationDate  created_at.iso8601
        xml.NeedHostel        entrant.need_hostel
        xml.StatusID          status_id
        xml.SelectedCompetitiveGroups do
          xml.CompetitiveGroupID competitive_group_item.competitive_group.id
        end
        xml.SelectedCompetitiveGroupItems do
          xml.CompetitiveGroupItemID competitive_group_item_id
        end
        xml.FinSourceAndEduForms do
          xml.FinSourceEduForm do
            xml.FinanceSourceID     (competitive_group_item.payed? ? 15 : 14)
            xml.EducationFormID     competitive_group_item.form
            xml.CompetitiveGroupID  competitive_group_item.competitive_group.id
            xml.CompetitiveGroupItemID  competitive_group_item_id
            xml.Priority            1
          end
        end
        xml.ApplicationDocuments do
          xml.IdentityDocument do
            xml.OriginalReceived true
            unless entrant.pseries.blank?
              xml.DocumentSeries  entrant.pseries
            end
            xml.DocumentNumber  entrant.pnumber
            xml.DocumentDate    entrant.pdate.iso8601
            xml.IdentityDocumentTypeID  entrant.identity_document_type_id
            xml.NationalityTypeID       entrant.nationality_type_id
            xml.BirthDate               entrant.birthday.iso8601
          end
          xml.EduDocuments do
            xml << entrant.edu_document.to_nokogiri(self).root.to_xml
          end
        end

        has_scores = false
        results = entrant.exam_results.in_competitive_group(competitive_group)
        results.each do |r|
          has_scores = true if r.score
        end

        if has_scores
          xml.EntranceTestResults do
            results.each do |r|
              if r.score
                xml << r.to_fis(competitive_group_id: competitive_group.id).to_xml
              end
            end
          end
        end
      end
    end

    builder.doc
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.application {
        xml.id_   id
        xml.abitpoints abitpoints
        xml.benefit (benefits.collect{|x| x.id}.include? 4 ? 4 : (benefits.collect{|x| x.id}.include? 1 ? 1 : nil))
        xml.number number
        xml.exams do
          abitexams.each { |exam| xml << exam.to_nokogiri.root.to_xml }
        end
        # xml << entrant.to_nokogiri.root.to_xml
        xml << contract.to_nokogiri.root.to_xml if contract
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end

  private

  # TODO Переделать и перенести в Group.
  def find_group(competitive_group_item, ioo)
    direction = competitive_group_item.direction

    specialities = Speciality.from_direction(direction)
    if specialities.any?
      speciality = specialities.first
    else
      speciality = Speciality.find_by_speciality_code(direction.new_code)
    end

    form = ioo ? 105 : competitive_group_item.matrix_form
    group = Group.filter(speciality: [speciality.id], form: [form], course: [1]).first if speciality
    if group
      return group
    else
      return { speciality: direction.code+'.'+direction.qualification_code.to_s, form: (case form
                                                                                          when 101
                                                                                            'очная'
                                                                                          when 102
                                                                                            'очно-заочная'
                                                                                          when 103
                                                                                            'заочная'
                                                                                          when 105
                                                                                            'дистанционная'
                                                                                        end) }
    end
  end
end
