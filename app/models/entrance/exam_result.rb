class Entrance::ExamResult < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  # @!group Расширения

  # @!group Поля

  enum form: { use: 1, university: 2, payed_test: 3 }

  # @!group Ассоциации

  belongs_to :exam,    class_name: 'Entrance::Exam'
  belongs_to :entrant, class_name: 'Entrance::Entrant'

  # @!group Валидации

  # @!group Поведение

  # @!group Скоупы

  # default_scope do
  #   includes(:entrant).joins(:entrant).
  #     order('entrance_entrants.last_name').
  #     order('entrance_entrants.first_name').
  #     order('entrance_entrants.patronym')
  # end

  scope :in_competitive_group, -> competitive_group do
    joins('LEFT JOIN entrance_test_items ON entrance_test_items.exam_id = entrance_exam_results.exam_id').
    where('entrance_test_items.competitive_group_id = ?', competitive_group.id).
    where('entrance_test_items.id IS NOT NULL')
  end

  scope :by_exam, -> exam_id { where(exam_id: exam_id) }
  scope :by_exam_name, -> exam_name do
    joins(:exam).where("entrance_exams.name = '#{exam_name}'")
  end

  scope :use, -> { where(form: 1) }
  scope :internal, -> { where(form: 2) }

  # @!group Методы

  def exam_type
    case form
      when 'use'
        'ЕГЭ'
      when 'university'
        'ВИ'
    end
  end

  def to_fis(opts = {})
    unless opts[:competitive_group_id]
      raise 'Не указан идентификатор конкурсной группы.'
    end

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.EntranceTestResult do
        xml.UID                 "test_result_#{opts[:application].id * 10000 + id}"
        xml.ResultValue         score

        if opts[:application].benefits.any? && opts[:application].benefits.first.benefit_kind.ege_100?
          xml.ResultSourceTypeID 3
        else
          xml.ResultSourceTypeID  self[:form]
        end

        xml.EntranceTestSubject { fis_entrance_test_subject(xml) }
        xml.EntranceTestTypeID  exam.creative ? 2 : 1

        if opts[:application].benefits.any? && opts[:application].benefits.first.benefit_kind.ege_100?
          # Олимпиады.
          xml.CompetitiveGroupUID  opts[:application].competitive_group.fis_uid
        elsif opts[:application].benefits.any?
          # Квота особых прав
          xml.CompetitiveGroupUID  "#{opts[:application].competitive_group.fis_uid}_quota"
        elsif opts[:application].competitive_group.name.include?('Крым')
          # Квота Крым
          xml.CompetitiveGroupUID  opts[:application].competitive_group.fis_uid
        elsif opts[:application].competitive_group_target_item_id.present?
          # Квота целевого приема
          xml.CompetitiveGroupUID  "#{opts[:application].competitive_group.fis_uid}_target"
        else
          xml.CompetitiveGroupUID  opts[:application].competitive_group.fis_uid
        end

        if opts[:application].benefits.any? && opts[:application].benefits.first.benefit_kind.ege_100?
          xml.ResultDocument do
            xml.OlympicDocument do
              xml.UID opts[:application].benefits.first.olympic_document.id
              xml.DocumentSeries opts[:application].benefits.first.olympic_document.series
              xml.DocumentNumber opts[:application].benefits.first.olympic_document.number
              xml.DiplomaTypeID opts[:application].benefits.first.olympic_document.diploma_type_id
              xml.OlympicID opts[:application].benefits.first.olympic_document.olympic_id
              xml.ProfileID opts[:application].benefits.first.olympic_document.profile_id
              xml.ClassNumber opts[:application].benefits.first.olympic_document.class_number
            end
          end
        elsif 2 == self[:form].to_i
          xml.ResultDocument do
            xml.InstitutionDocument do
              xml.DocumentTypeID 2
              xml.DocumentNumber opts[:application].number
              xml.DocumentDate opts[:application].created_at.to_date.iso8601
            end
          end
        elsif 1 == self[:form].to_i
          # xml.ResultDocument do
          #   xml.EgeDocumentID "entrant_check_#{opts[:application].entrant.checks.last.id}"
          # end
        end
      end
    end

    builder.doc
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.exam_result {
        xml.id_   id
        xml.score score
        xml.name exam.name
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end

  private

  def fis_entrance_test_subject(xml)
    # if 12014 == entrant.campaign_id || 22014 == entrant.campaign_id
    #   xml.SubjectName exam.name
    # else
      if exam.use_subject_id
        xml.SubjectID exam.use_subject_id
      else
        xml.SubjectName exam.name
      end
    # end
  end
end
