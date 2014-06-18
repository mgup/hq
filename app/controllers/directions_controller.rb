class DirectionsController < ApplicationController
  load_and_authorize_resource :direction

  def index
    # Конечно, корявый способ...
    # doc = Nokogiri::XML(open('/Users/anna/Downloads/Directions 2014-06-18.xml'))
    # doc.css('DictionaryItem').each do |node|
    #   record = Direction.new
    #   record.id = node.xpath('ID').inner_text
    #   record.code = node.xpath('Code').inner_text
    #   record.new_code = node.xpath('NewCode').inner_text
    #   record.name = node.xpath('Name').inner_text
    #   record.qualification_code = node.xpath('QualificationCode').inner_text
    #   record.ugs_code = node.xpath('UGSCode').inner_text
    #   record.ugs_name = node.xpath('UGSName').inner_text
    #   record.save
    # end

    # doc = Nokogiri::XML(open('/Users/anna/Downloads/11.xml'))
    # doc.css('DictionaryItem').each do |node|
    #   record = Entrance::TestType.new
    #   record.id = node.xpath('ID').inner_text
    #   record.name = node.xpath('Name').inner_text
    #   record.save
    # end

    # doc = Nokogiri::XML(open('/Users/anna/Downloads/30.xml'))
    # doc.css('DictionaryItem').each do |node|
    #   record = BenefitKind.new
    #   record.id = node.xpath('ID').inner_text
    #   record.name = node.xpath('Name').inner_text
    #   record.save
    # end

    xml = Nokogiri::XML(open('/Users/anna/Downloads/CompetitiveGroups 2014-06-17.xml'))
    hash = Hash.from_xml("#{xml}")
    hash = rename_keys(hash, {'CompetitiveGroup' => :competitive_group, 'CampaignUID' => :campaign_id, 'CompetitiveGroupID' => :id,
                              'Course' => :course, 'Items' => :items_attributes, 'CompetitiveGroupItemID' => :id, 'Name' => :name,
                              'DirectionID' => :direction_id, 'EducationLevelID' => :education_level_id, 'NumberBudgetO' => :number_budget_o,
                              'NumberBudgetOZ' => :number_budget_oz, 'NumberBudgetZ' => :number_budget_z, 'NumberPaidO' => :number_paid_o,
                              'NumberPaidOZ' => :number_paid_oz, 'NumberPaidZ' => :number_paid_z, 'NumberQuotaO' => :number_quota_o,
                              'NumberQuotaOZ' => :number_quota_oz, 'NumberQuotaZ' => :number_quota_z, 'TargetOrganizations' => :target_organizations_attributes,
                              'NumberTargetO' => :number_target_o, 'NumberTargetOZ' => :number_target_oz, 'NumberTargetZ' => :number_target_z,
                              'SubjectName' => :subject_name, 'SubjectID' => :subject_id, 'Form' => :form
                      })
    keepers = [:campaign_id, :id, :course, :name]
    record = hash.first.second[:competitive_group].first
    record.keep_if{|k,_| keepers.include? k }
    Entrance::CompetitiveGroup.create record

    # doc = Nokogiri::XML(open('/Users/anna/Downloads/CompetitiveGroups 2014-06-17.xml'))
    # doc.css('CompetitiveGroup').each do |node|
    #   record = Entrance::CompetitiveGroup.create id: node.xpath('CompetitiveGroupID').inner_text, campaign_id: node.xpath('CampaignUID').inner_text,
    #                                              course: node.xpath('Course').inner_text, name: node.xpath('Name').inner_text, items_attributes: [],
    #                                              target_organizations_attributes: [], test_items_attributes: []
    #   record.save
    # end
  end

  private
  def rename_keys(hash, mapping)
    result = {}
    hash.map do |k,v|
      mapped_key = mapping[k] ? mapping[k] : k
      result[mapped_key] = v.kind_of?(Hash) ? rename_keys(v, mapping) : v
      result[mapped_key] = v.collect{ |obj| rename_keys(obj, mapping) if obj.kind_of?(Hash)} if v.kind_of?(Array)
    end
    result
  end
end