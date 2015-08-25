class Entrance::Application < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: 'Entrance::Campaign'
  belongs_to :entrant, class_name: 'Entrance::Entrant'
  belongs_to :competitive_group_item, class_name: 'Entrance::CompetitiveGroupItem'
  belongs_to :competitive_group_target_item, class_name: 'Entrance::CompetitiveGroupTargetItem'

  delegate :direction, to: :competitive_group_item
  delegate :department, to: :direction
  delegate :form, to: :competitive_group_item
  delegate :competitive_group, to: :competitive_group_item
  delegate :payed?, to: :competitive_group_item

  has_many :benefits, class_name: 'Entrance::Benefit'

  has_one :contract, class_name: 'Entrance::Contract'

  belongs_to :order, class_name: 'Office::Order'

  after_create do |application|
    Entrance::Log.create entrant_id: application.entrant.id,
                         user_id: User.current.id,
                         comment: "Создано заявление #{application.id}."
  end

  # after_update do |application|
  #   Entrance::Log.create entrant_id: application.entrant.id,
  #                        user_id: User.current.id,
  #                        comment: "Обновлено заявление #{[application.number, application.id].join(', ')}."
  # end

  # default_scope do
  #   where('status_id != ?', 6)
  # end

  default_scope do
    joins(:entrant).where(entrance_entrants: { visible: 1 })
  end

  scope :actual, -> { where('status_id != ?', 6).where('status_id != ?', 5) }
  scope :with_order, -> { where(status_id: 8) }
  scope :without_order, -> { where('status_id != ?', 8) }

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

  scope :from_faculty, -> (faculty_id) do
    joins(:competitive_group_item).joins(competitive_group_item: :direction).
    where('directions.department_id = ?', faculty_id)
  end

  scope :paid, -> do
  #where('number_paid_o > 0 OR number_paid_oz > 0 OR number_paid_z > 0').
#     where('number_budget_o = 0 AND number_budget_oz = 0 AND number_budget_z = 0').
#     where('number_quota_o = 0 AND number_quota_oz = 0 AND number_quota_z = 0')
      where(is_payed: true)
  end

  scope :not_paid, -> do
    # where('number_paid_o = 0 AND number_paid_oz = 0 AND number_paid_z = 0')
    where(is_payed: false)
  end

  scope :o_form, -> do
    # where('number_budget_o > 0 OR number_paid_o > 0 OR number_quota_o > 0')
    where(education_form_id: 11)
  end

  scope :oz_form, -> do
    # where('number_budget_oz > 0 OR number_paid_oz > 0 OR number_quota_oz > 0')
    where(education_form_id: 12)
  end

  scope :z_form, -> do
    # where('number_budget_z > 0 OR number_paid_z > 0 OR number_quota_z > 0')
    where(education_form_id: 10)
  end

  scope :for_rating, -> do
    includes(:benefits)
    .select('COALESCE(SUM(r.score), 0) AS total_score')
    .select('MIN(COALESCE(r.score, 0) >= ti.min_score) AS pass_min_score')
    .select('entrance_applications.*')
    .joins('LEFT JOIN competitive_group_items AS i ON i.id = entrance_applications.competitive_group_item_id')
    .joins('LEFT JOIN competitive_groups AS g ON g.id = i.competitive_group_id')
    .joins('LEFT JOIN entrance_test_items AS ti ON ti.competitive_group_id = g.id')
    .joins('LEFT JOIN entrance_exam_results AS r ON r.entrant_id = entrance_applications.entrant_id AND ti.exam_id = r.exam_id')
    .joins('LEFT JOIN directions AS d ON d.id = i.direction_id')
    .where('status_id != 6')
    .where('status_id != 5')
    .group('entrance_applications.id')
    # select('CASE b.benefit_kind_id WHEN 1 THEN 1 WHEN 4 THEN 4 ELSE NULL END AS benefit_type')
    # .joins('LEFT JOIN entrance_benefits AS b ON b.application_id = entrance_applications.id')
    # .select('pr.score AS priority_score')
    # .joins('LEFT JOIN entrance_exam_results AS pr ON pr.entrant_id = entrance_applications.entrant_id AND ti.exam_id = pr.exam_id AND ti.entrance_test_priority = 1')
    # .order('benefit_type = 1 DESC')
    # .order('benefit_type = 4 DESC')
    # .order('total_score DESC')
    # .order('priority_score DESC')
  end

  def self.sort_applications
    lambda do |a, b|
      sum1 = a.abitpoints
      sum2 = b.abitpoints
      # 0
      if sum1 > sum2
        -1
      elsif sum1 < sum2
        1
      else
        case b.abitexams.map{|e| e ? e.score : 0} <=> a.abitexams.map{|e| e ? e.score : 0}
        when 1 then 1
        when -1 then -1
        when 0 then 0 #fail("Нужна проверка преимущественного права. #{a.inspect} #{b.inspect}")
        end
      end
    end
  end

  def self.sort_applications_for_sort_by
    lambda do |a|
      res = a.original? ? '1' : '0'
      res += sprintf('%03d', a.abitpoints.to_s)
      res += a.abitexams.map{ |e| e ? sprintf('%03d', e.score) : '000' }.join

      res
    end
  end

  def abitpoints
    sum = 0
    competitive_group_item.competitive_group.test_items.collect{|x| x.exam}.each do |exam|
      sum += entrant.exam_results.by_exam(exam.id).last.score if entrant.exam_results.by_exam(exam.id).last.score
    end

    sum += abitachievements

    sum
  end

  def avgpoints
    1.0 * abitpoints / abitexams.size
  end

  def abitexams
    exams = []
    competitive_group_item.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam }.each do |exam|
      exams << entrant.exam_results.by_exam(exam.id).last
    end
    exams
  end

  def abitachievements
    sum = 0
    entrant.achievements.each do |a|
      if direction.id == 280
        next if a.entrance_achievement_type_id == 13
        sum += a.score || 0
      else
        next if a.entrance_achievement_type_id == 14
        sum += a.score || 0
      end
    end
    sum
  end

  # Имеющие ЕГЭ (функция названа неверное, потом нужно поправить)
  def only_use?
    abitexams.find_all { |r| r.use? }.size > 0
  end

  def has_creative_exams?
    abitexams.find_all { |r| r.exam.creative }.size > 0
  end

  def pass_min_score?
    passed = true
    competitive_group_item.competitive_group.test_items.order(:entrance_test_priority).each do |test_item|
      if entrant.exam_results.by_exam(test_item.exam.id).last.nil?
        passed = false
      elsif entrant.exam_results.by_exam(test_item.exam.id).last.score.nil?
        passed = false
      else
        passed &&= entrant.exam_results.by_exam(test_item.exam.id).last.score >= test_item.min_score
      end
    end
    passed
  end

  def self.rating(form = '11', payment = '14', direction = '1887')
    form_method = case form.to_s
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

    where('d.id = ?', direction).send(form_method).send(payment_method)
  end

  def self.direction_stats(campaign, direction)
    applications = campaign.applications.actual.for_direction(direction)

    competitive_group_items = applications.map(&:competitive_group_item).uniq

    stats = {}
    [:budget, :paid].each do |payment|
      stats[payment] = {}
      [:o, :oz, :z].each do |form|
        places = if :budget == payment
          case form
          when :o   then competitive_group_items.map(&:total_budget_o).sum
          when :oz  then competitive_group_items.map(&:total_budget_oz).sum
          when :z   then competitive_group_items.map(&:total_budget_z).sum
          end
        elsif :paid == payment
          case form
          when :o   then competitive_group_items.map(&:total_paid_o).sum
          when :oz  then competitive_group_items.map(&:total_paid_oz).sum
          when :z   then competitive_group_items.map(&:total_paid_z).sum
          end
        end

        stats[payment][form] = { total: 0, original: 0, enrolled: 0, places: places, contest: 0, real_contest: 0 }
      end
    end

    applications.each do |app|
      # form = case app.education_form_id
      form = case app.education_form_id
        when 11
          :o
        when 12
          :oz
        when 10
          :z
      end

      # payment_form = app.competitive_group_item.payed? ? :paid : :budget
      payment_form = app.is_payed ? :paid : :budget

      stats[payment_form][form][:total] += 1


      if app.is_payed
        stats[payment_form][form][:original] += 1 if app.contract
      else
        stats[payment_form][form][:original] += 1 if app.original?
      end


      stats[payment_form][form][:enrolled] += 1 if app.status_id == 8
    end

    [:budget, :paid].each do |payment_form|
      [:o, :oz, :z].each do |form|
        stats[payment_form][form][:contest] = (1.0 * stats[payment_form][form][:total] / stats[payment_form][form][:places]).round(2)
        stats[payment_form][form][:real_contest] = (1.0 * stats[payment_form][form][:original] / stats[payment_form][form][:places]).round(2)
      end
    end

    stats
  end

  def self.group_by_form_payment_and_direction

    stats = {}
    [:not_paid, :paid].each do |payment|
      stats[payment] = {}
      [:o, :oz, :z].each do |form|
        stats[payment][form] = self.send(payment).send("#{form}_form").group_by(&:direction)
      end
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
    else
      false
    end
  end

  def special_rights
    if benefits && benefits.first
      benefits.first.benefit_kind.special_rights?
    else
      false
    end
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
    totals = {
      budget: {
        o: {
          total: 0,
          original: 0,
          places: 0,
          enrolled: 0
        }
      },
      paid: {
        o: {
          total: 0,
          original: 0,
          places: 0,
          enrolled: 0
        },
        oz: {
          total: 0,
          original: 0,
          places: 0,
          enrolled: 0
        },
        z: {
          total: 0,
          original: 0,
          places: 0,
          enrolled: 0
        }
      }
    }

    Department.faculties.map do |faculty|
      applications = faculty.directions.for_campaign(campaign).map do |direction|
        stats = self.direction_stats(campaign, direction)

        row = [direction.description]

        [:budget].each do |p|
          [:o].each do |f|
            row << if stats[p][f][:places].zero?
                     ''
                   else
                     "#{stats[p][f][:total]} (#{stats[p][f][:original]}) / #{stats[p][f][:places]} (#{stats[p][f][:enrolled]}) / #{stats[p][f][:contest]} (#{stats[p][f][:real_contest]})"
                   end

            totals[p][f][:total] += stats[p][f][:total]
            totals[p][f][:original] += stats[p][f][:original]
            totals[p][f][:places] += stats[p][f][:places]
            totals[p][f][:enrolled] += stats[p][f][:enrolled]
          end
        end

        [:paid].each do |p|
          [:o, :oz].each do |f|
            row << if stats[p][f][:places].zero?
                     ''
                   else
                     "#{stats[p][f][:total]} (#{stats[p][f][:original]}) / #{stats[p][f][:places]} (#{stats[p][f][:enrolled]}) / #{stats[p][f][:contest]} (#{stats[p][f][:real_contest]})"
                   end

            totals[p][f][:total] += stats[p][f][:total]
            totals[p][f][:original] += stats[p][f][:original]
            totals[p][f][:places] += stats[p][f][:places]
            totals[p][f][:enrolled] += stats[p][f][:enrolled]
          end
        end

        row
      end

      totals[:budget][:o][:contest] = (1.0 * totals[:budget][:o][:total] / totals[:budget][:o][:places]).round(2)
      totals[:budget][:o][:real_contest] = (1.0 * totals[:budget][:o][:original] / totals[:budget][:o][:places]).round(2)
      totals[:paid][:o][:contest] = (1.0 * totals[:paid][:o][:total] / totals[:paid][:o][:places]).round(2)
      totals[:paid][:o][:real_contest] = (1.0 * totals[:paid][:o][:original] / totals[:paid][:o][:places]).round(2)
      totals[:paid][:oz][:contest] = (1.0 * totals[:paid][:oz][:total] / totals[:paid][:oz][:places]).round(2)
      totals[:paid][:oz][:real_contest] = (1.0 * totals[:paid][:oz][:original] / totals[:paid][:oz][:places]).round(2)
      totals[:paid][:z][:contest] = (1.0 * totals[:paid][:z][:total] / totals[:paid][:z][:places]).round(2)
      totals[:paid][:z][:real_contest] = (1.0 * totals[:paid][:z][:original] / totals[:paid][:z][:places]).round(2)

      if 3 == faculty.id
        applications = applications.push([
                                           'ВСЕГО',
                                           "#{totals[:budget][:o][:total]} (#{totals[:budget][:o][:original]}) / #{totals[:budget][:o][:places]} (#{totals[:budget][:o][:enrolled]}) / #{totals[:budget][:o][:contest]} (#{totals[:budget][:o][:real_contest]})",
                                           "#{totals[:paid][:o][:total]} (#{totals[:paid][:o][:original]}) / #{totals[:paid][:o][:places]} (#{totals[:paid][:o][:enrolled]}) / #{totals[:paid][:o][:contest]} (#{totals[:paid][:o][:real_contest]})",
                                           "#{totals[:paid][:oz][:total]} (#{totals[:paid][:oz][:original]}) / #{totals[:paid][:oz][:places]} (#{totals[:paid][:oz][:enrolled]}) / #{totals[:paid][:oz][:contest]} (#{totals[:paid][:oz][:real_contest]})"#,
                                         # "#{totals[:paid][:z][:total]} (#{totals[:paid][:z][:original]}) / #{totals[:paid][:z][:places]} (#{totals[:paid][:z][:enrolled]}) / #{totals[:paid][:z][:contest]} (#{totals[:paid][:z][:real_contest]})"
                                         ])
      end

      {
        faculty: faculty.name,
        applications: applications
      }
    end
  end

  def called_back?
    6 == status_id
  end

  # Внесение абитуриента из заявления в список студентов.
  def enroll
    if contract
      person = contract.student.person
      student_id = contract.student_id
      save!
    else
      group = find_group(competitive_group_item, entrant.ioo, matrix_form_number)
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
        person = Person.create!(
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
          student_foreign: (3 == entrant.identity_document_type_id.to_i || 1 != entrant.nationality_type_id.to_i),
          army: army,
          last_name_hint: entrant.last_name,
          first_name_hint: entrant.first_name,
          patronym_hint: entrant.patronym,
          student_oldid: 0,
          student_oldperson: 0,
          student_benefits: 1,
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
              student_group_tax:  is_payed ? Student::PAYMENT_OFF_BUDGET : Student::PAYMENT_BUDGET,
              student_group_status: Student::STATUS_ENTRANT,
              student_group_speciality: group.speciality.id,
              student_group_form: group.form,
              student_group_oldgroup: 0,
              student_group_oldstudent: 0,
              student_group_a_state_line: (52015 == campaign_id ? 1 : 0),
              entrant_id: entrant.id
            }
          }
        )
      end
    end

    order = Office::Order.entrance
    .joins(:metas)
    .where("order_meta.order_meta_pattern = 'Конкурсная группа' && order_meta.order_meta_text = '#{competitive_group_item.competitive_group.id}'").last
    if order && order.draft? && (order.students_in_order.first.student.education_form == matrix_form) && (order.students_in_order.first.student.off_budget? == is_payed)
      order.students_in_order << Office::OrderStudent.create!(
          order_student_student: person.id,
          order_student_student_group_id: person.students.first.id,
          order_student_cause: 0,
          order_student_order: order.id
      )
    else
      order = Office::Order.create!(
          order_status: Office::Order::STATUS_DRAFT,
          order_template: 16,
          students_in_order_attributes: {
            '0' => {
              order_student_student: person.id,
              order_student_student_group_id: person.students.first.id,
              order_student_cause: 0
            }
          },
          metas_attributes: {
              '0' => {
                  order_meta_type: 1,
                  order_meta_pattern: 'Конкурсная группа',
                  order_meta_object: 0,
                  order_meta_text: competitive_group_item.competitive_group.id
              }
          }
      )
      order.metas.last.update(object: order.id)
      order.metas.last.save!
    end
    update(status_id: 8, order_id: order.id)
    save!
  end

  def to_fis
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Application do
        xml.UID               id
        xml.ApplicationNumber number
        xml.Entrant do
          xml.UID         "entrant_#{entrant.id}"
          xml.FirstName   entrant.first_name
          xml.MiddleName  entrant.patronym
          xml.LastName    entrant.last_name
          xml.GenderID    entrant[:gender]
        end
        xml.RegistrationDate  created_at.iso8601
        xml.NeedHostel        entrant.need_hostel
        xml.StatusID          4 # status_id
        xml.SelectedCompetitiveGroups do
          xml.CompetitiveGroupID competitive_group_item.competitive_group.id
        end
        xml.SelectedCompetitiveGroupItems do
          xml.CompetitiveGroupItemID competitive_group_item_id
        end
        xml.FinSourceAndEduForms do
          xml.FinSourceEduForm do
            xml.FinanceSourceID is_payed ? 15 : (competitive_group_target_item_id.nil? ? 14 : 16) # (competitive_group_item.payed? ? 15 : ( competitive_group_target_item_id.nil? ? 14 : 16))
            xml.EducationFormID     education_form_id
            xml.CompetitiveGroupID  competitive_group_item.competitive_group.id
            xml.CompetitiveGroupItemID  competitive_group_item_id
            xml.Priority            1

            unless competitive_group_target_item_id.nil?
              # xml.TargetOrganizationUID competitive_group_target_item.target_organization.id
              xml.TargetOrganizationUID case competitive_group_target_item.target_organization.name
                                        when 'ФАПМК'
                                          '2015-1'
                                        when 'Ульяновский Дом печати'
                                          '2015-2'
              #                           when 'Министерство образования и науки Республики Бурятия'
              #                             '2014-3'
              #                           when 'Министерство образования, науки и по делам молодежи КБР'
              #                             '2014-4'
                                        end
            end
          end
        end
        xml.ApplicationDocuments do
          xml.IdentityDocument do
            xml.OriginalReceived true
            xml.DocumentSeries  entrant.pseries.blank? ? 'б/с' : entrant.pseries
            xml.DocumentNumber  entrant.pnumber
            xml.DocumentDate    entrant.pdate.iso8601
            xml.IdentityDocumentTypeID  entrant.identity_document_type_id
            xml.NationalityTypeID       entrant.nationality_type_id
            xml.BirthDate               entrant.birthday.iso8601
          end
          xml.EduDocuments do
            xml << entrant.edu_document.to_nokogiri(self).root.to_xml
          end

          if abitachievements > 0
            xml.CustomDocuments do
              entrant.achievements.each do |a|
                if direction.id == 280
                  next if a.entrance_achievement_type_id == 13
                else
                  next if a.entrance_achievement_type_id == 14
                end

                xml.CustomDocument do
                  xml.UID "IA#{a.id}"
                  xml.DocumentTypeNameText a.document.present? ?  a.document : "Протокол #{a.id}"
                  xml.OriginalReceived true
                end
              end
            end
          end
        end
        unless benefits.empty?
        # xml.ApplicationCommonBenefit do
        #   xml.UID benefits.first.id
        #   xml.CompetitiveGroupID competitive_group_item.competitive_group.id
        #   xml.DocumentTypeID  benefits.first.document_type_id
        #   xml.BenefitKindID  benefits.first.benefit_kind_id
        #   xml.DocumentReason do
        #     if benefits.first.olympic_document
        #       xml.OlympicDocument do
        #         xml.UID benefits.first.olympic_document.id
        #         xml.OriginalReceived true
        #         xml.DocumentNumber benefits.first.olympic_document.number
        #         xml.DiplomaTypeID benefits.first.olympic_document.diploma_type_id
        #         xml.OlympicID benefits.first.olympic_document.olympic_id
        #         xml.LevelID benefits.first.olympic_document.level_id
        #       end
        #     elsif benefits.first.medical_disability_document
        #       xml.MedicalDocuments do
        #         xml.BenefitDocument do
        #           if benefits.first.medical_disability_document.medical?
        #             xml.MedicalDocument do
        #               xml.UID benefits.first.medical_disability_document.id
        #               xml.OriginalReceived true
        #               xml.DocumentNumber benefits.first.medical_disability_document.number
        #               xml.DocumentDate benefits.first.medical_disability_document.date
        #               xml.DocumentOrganization benefits.first.medical_disability_document.organization
        #             end
        #           else
        #             xml.DisabilityDocument do
        #               xml.UID benefits.first.medical_disability_document.id
        #               xml.OriginalReceived true
        #               xml.DocumentSeries benefits.first.medical_disability_document.series.blank? ? 'б/с' : benefits.first.medical_disability_document.series
        #               xml.DocumentNumber benefits.first.medical_disability_document.number
        #               xml.DocumentDate benefits.first.medical_disability_document.date
        #               xml.DocumentOrganization benefits.first.medical_disability_document.organization
        #               xml.DisabilityTypeID benefits.first.medical_disability_document.disability_type_id
        #             end
        #           end
        #         end
        #         xml.AllowEducationDocument do
        #           xml.UID benefits.first.allow_education_document.id
        #           xml.OriginalReceived true
        #           xml.DocumentNumber benefits.first.allow_education_document.number
        #           xml.DocumentDate benefits.first.allow_education_document.date
        #           xml.DocumentOrganization benefits.first.allow_education_document.organization
        #         end
        #       end
        #     elsif benefits.first.custom_document
        #       xml.CustomDocument do
        #         xml.UID benefits.first.custom_document.id
        #         xml.OriginalReceived true
        #         xml.DocumentSeries benefits.first.custom_document.series.blank? ? 'б/с' : benefits.first.custom_document.series
        #         xml.DocumentNumber benefits.first.custom_document.number
        #         xml.DocumentDate benefits.first.custom_document.date
        #         xml.DocumentOrganization benefits.first.custom_document.organization
        #         xml.DocumentTypeNameText benefits.first.custom_document.type_name
        #       end
        #     end
        #   end
        # end

          if 16233 == id
            # 100 баллов за ЕГЭ в exam_result
          else
            xml.ApplicationCommonBenefits do
              xml.ApplicationCommonBenefit do
                # ФИС требует, чтобы льготы передаваемые через
                # ApplicationCommonBenefits и ApplicationCommonBenefit имели
                # различные UID. Надеюсь, что у нас не скоро будет 100000
                # абитуриентов со льготами.
                # xml.UID (benefits.first.id + 100000)
                xml.UID "benefit_#{benefits.first.id}"
                xml.CompetitiveGroupID competitive_group_item.competitive_group.id
                xml.DocumentTypeID  benefits.first.document_type_id
                xml.BenefitKindID  benefits.first.benefit_kind_id
                xml.DocumentReason do
                  if 17771 == id.to_i
                    xml.OlympicTotalDocument do
                      xml.UID "olympic_total_document_1"
                      xml.DocumentSeries 'б/с'
                      xml.DocumentNumber '2015-II-1194'
                      xml.DiplomaTypeID 2
                      xml.Subjects do
                        xml.SubjectBriefData do
                          xml.SubjectID 9
                        end
                      end
                    end

                  end

                  if benefits.first.olympic_document
                    xml.OlympicDocument do
                      xml.UID "olympic_document_#{benefits.first.olympic_document.id}"
                      xml.OriginalReceived true
                      xml.DocumentNumber benefits.first.olympic_document.number
                      xml.DiplomaTypeID benefits.first.olympic_document.diploma_type_id
                      xml.OlympicID benefits.first.olympic_document.olympic_id
                      xml.LevelID benefits.first.olympic_document.level_id
                    end
                  elsif benefits.first.medical_disability_document
                    xml.MedicalDocuments do
                      xml.BenefitDocument do
                        if benefits.first.medical_disability_document.medical?
                          xml.MedicalDocument do
                            xml.UID "medical_document_#{benefits.first.medical_disability_document.id}"
                            xml.OriginalReceived true
                            xml.DocumentNumber benefits.first.medical_disability_document.number
                            xml.DocumentDate benefits.first.medical_disability_document.date
                            xml.DocumentOrganization benefits.first.medical_disability_document.organization
                          end
                        else
                          xml.DisabilityDocument do
                            xml.UID "disability_document_#{benefits.first.medical_disability_document.id}"
                            xml.OriginalReceived true
                            xml.DocumentSeries benefits.first.medical_disability_document.series.blank? ? 'б/с' : benefits.first.medical_disability_document.series
                            xml.DocumentNumber benefits.first.medical_disability_document.number
                            xml.DocumentDate benefits.first.medical_disability_document.date
                            xml.DocumentOrganization benefits.first.medical_disability_document.organization
                            xml.DisabilityTypeID benefits.first.medical_disability_document.disability_type_id
                          end
                        end
                      end
                      xml.AllowEducationDocument do
                        xml.UID "allow_education_document_#{benefits.first.allow_education_document.id}"
                        xml.OriginalReceived true
                        xml.DocumentNumber benefits.first.allow_education_document.number
                        xml.DocumentDate benefits.first.allow_education_document.date
                        xml.DocumentOrganization benefits.first.allow_education_document.organization
                      end
                    end
                  elsif benefits.first.custom_document
                    xml.CustomDocument do
                      xml.UID "custom_document_#{benefits.first.custom_document.id}"
                      xml.OriginalReceived true
                      xml.DocumentSeries benefits.first.custom_document.series.blank? ? 'б/с' : benefits.first.custom_document.series
                      xml.DocumentNumber benefits.first.custom_document.number
                      xml.DocumentDate benefits.first.custom_document.date
                      xml.DocumentOrganization benefits.first.custom_document.organization
                      xml.DocumentTypeNameText benefits.first.custom_document.type_name
                    end
                  end
                end
              end
            end
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
                xml << r.to_fis(competitive_group_id: competitive_group.id, application: self).xpath('/EntranceTestResult').to_xml.to_str
              end
            end
          end
        end

        if abitachievements > 0
          xml.IndividualAchievements do
            entrant.achievements.each do |a|
              if direction.id == 280
                next if a.entrance_achievement_type_id == 13
              else
                next if a.entrance_achievement_type_id == 14
              end

              xml.IndividualAchievement do
                xml.IAUID "individual_achievement_#{a.id}"
                xml.IAName a.achievement_type.name
                xml.IAMark a.score if a.score.present?
                xml.IADocumentUID "IA#{a.id}"
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

        if out_of_competition
          xml.benefit 1
        elsif special_rights
          xml.benefit 4
        else
          xml.benefit nil
        end

        if competitive_group_target_item
          xml.target "целевой прием, договор №#{competitive_group_target_item.target_organization.contract_number} от #{I18n.l competitive_group_target_item.target_organization.contract_date}, #{competitive_group_target_item.target_organization.name}"
        else
          xml.target ''
        end

        # xml.benefit (benefits.collect{|x| x.id}.include? 4 ? 4 : (benefits.collect{|x| x.id}.include? 1 ? 1 : nil))

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

  def enrolled?
    entrant.student && status_id == 8
    # fail '123' if 13083 == id
    # if entrant.student
    #   if entrant.student.speciality.code.split('.')[0] == direction.code && entrant.student.speciality.code.split('.')[1] == direction.qualification_code.to_s
    #     true
    #   else
    #     false
    #   end
    # else
    #   false
    # end
  end

  def matrix_form
    case education_form_id
    when 11
      'fulltime'
    when 12
      'semitime'
    when 10
      entrant.ioo ? 'distance' : 'postal'
    else
      fail 'Неизвестная форма обучения'
    end
  end
  
  def education_form_name
    case education_form_id
    when 11
      'очная'
    when 12
      'очно-заочная'
    when 10
      'заочная'
    else
      fail 'Неизвестная форма обучения'
    end
  end
  
  def budget_name
    is_payed ? 'по договорам' : 'бюджетная основа'
  end

  def matrix_form_number
    case education_form_id
    when 11
      101
    when 12
      102
    when 10
      entrant.ioo ? 105 : 103
    else
      fail 'Неизвестная форма обучения'
    end
  end

  # TODO Переделать и перенести в Group.
  def find_group(competitive_group_item, ioo, matrix_form_number)
    direction = competitive_group_item.direction

    specialities = Speciality.from_direction(direction)

    if specialities.any?
      speciality = specialities.first
    else
      speciality = Speciality.find_by_speciality_code(direction.new_code)
    end

    # form = application.matrix_form_number   # competitive_group_item.matrix_form
    form = matrix_form_number   # competitive_group_item.matrix_form
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
