class Entrance::Application < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: 'Entrance::Campaign'
  belongs_to :entrant, class_name: 'Entrance::Entrant'
  belongs_to :competitive_group_item, class_name: 'Entrance::CompetitiveGroupItem'

  delegate :direction, to: :competitive_group_item
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
    select('CASE b.benefit_kind_id WHEN 1 THEN 1 WHEN 4 THEN 4 ELSE NULL END AS benefit_type').
    select('COALESCE(SUM(r.score), 0) AS total_score').
    select('MIN(r.score >= ti.min_score) AS pass_min_score').
    select('entrance_applications.*').
    joins('LEFT JOIN entrance_benefits AS b ON b.application_id = entrance_applications.id').
    joins('LEFT JOIN competitive_group_items AS i ON i.id = entrance_applications.competitive_group_item_id').
    joins('LEFT JOIN competitive_groups AS g ON g.id = i.competitive_group_id').
    joins('LEFT JOIN entrance_test_items AS ti ON ti.competitive_group_id = g.id').
    joins('LEFT JOIN entrance_exam_results AS r ON r.entrant_id = entrance_applications.entrant_id AND ti.exam_id = r.exam_id').
    joins('LEFT JOIN directions AS d ON d.id = i.direction_id').
    group('entrance_applications.id').
    order('benefit_type = 1 DESC').
	  order('benefit_type = 4 DESC').
    order('total_score DESC')
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
    stats = {
      budget: {
        o:  { total: 0, original: 0 },
        oz: { total: 0, original: 0 },
        z:  { total: 0, original: 0 }
      },
      paid: {
        o:  { total: 0, original: 0 },
        oz: { total: 0, original: 0 },
        z:  { total: 0, original: 0 }
      }
    }
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
    if benefits
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
    info = []
    Department.faculties.each do |faculty|
      applications = []
      faculty.directions.for_campaign(campaign).each do |direction|
        stats = self.direction_stats(campaign, direction)
        applications << [direction.description,
                         stats[:budget][:o][:total].zero? ? '' : "#{stats[:budget][:o][:total]} (#{stats[:budget][:o][:original]})",
                         stats[:budget][:oz][:total].zero? ? '' : "#{stats[:budget][:oz][:total]} (#{stats[:budget][:oz][:original]})",
                         stats[:budget][:z][:total].zero? ? '' : "#{stats[:budget][:z][:total]} (#{stats[:budget][:z][:original]})",
                         stats[:paid][:o][:total].zero? ? '' : "#{stats[:paid][:o][:total]} (#{stats[:paid][:o][:original]})",
                         stats[:paid][:oz][:total].zero? ? '' : "#{stats[:paid][:oz][:total]} (#{stats[:paid][:oz][:original]})",
                         stats[:paid][:z][:total].zero? ? '' : "#{stats[:paid][:z][:total]} (#{stats[:paid][:z][:original]})"]
      end
      info << {faculty: faculty.name, applications: applications}
    end

    return info
  end

  def called_back?
    6 == status_id
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
                xml.EntranceTestResult do
                  xml.UID r.id
                  xml.ResultValue r.score

                  xml.ResultSourceTypeID case r.form.to_sym
                                           when :use
                                             1
                                           when :university
                                             2
                                           else
                                             raise '123'
                                         end

                  xml.EntranceTestSubject do
                    if r.exam.use_subject_id
                      xml.SubjectID r.exam.use_subject_id
                    else
                      xml.SubjectName r.exam.name
                    end
                  end

                  xml.EntranceTestTypeID r.exam[:form]

                  xml.CompetitiveGroupID competitive_group.id
                  # xml.ResultDocument do
                  #
                  # end
                end
              end
            end
          end
        end
      end
    end

    builder.doc
  end
end
