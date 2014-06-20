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

    # doc = Nokogiri::XML(open('/Users/anna/Downloads/19.xml'))
    # doc.css('DictionaryItem').each do |node|
    #   record = Use::Olympic.new
    #   record.id = node.xpath('OlympicID').inner_text
    #   record.name = node.xpath('OlympicName').inner_text
    #   record.number = node.xpath('OlympicNumber').inner_text
    #   record.year = node.xpath('Year').inner_text
    #   record.save
    # end

    # xml = Nokogiri::XML(open('/Users/anna/Downloads/CompetitiveGroups 2014-06-17.xml'))
    # hash = Hash.from_xml("#{xml}")
    # hash = rename_keys(hash, {'CompetitiveGroup' => :competitive_group, 'CampaignUID' => :campaign_id, 'CompetitiveGroupID' => :id,
    #                           'Course' => :course, 'Items' => :items_attributes, 'CompetitiveGroupItemID' => :id, 'Name' => :name,
    #                           'DirectionID' => :direction_id, 'EducationLevelID' => :education_level_id, 'NumberBudgetO' => :number_budget_o,
    #                           'NumberBudgetOZ' => :number_budget_oz, 'NumberBudgetZ' => :number_budget_z, 'NumberPaidO' => :number_paid_o,
    #                           'NumberPaidOZ' => :number_paid_oz, 'NumberPaidZ' => :number_paid_z, 'NumberQuotaO' => :number_quota_o,
    #                           'NumberQuotaOZ' => :number_quota_oz, 'NumberQuotaZ' => :number_quota_z, 'TargetOrganizations' => :target_organizations_attributes,
    #                           'NumberTargetO' => :number_target_o, 'NumberTargetOZ' => :number_target_oz, 'NumberTargetZ' => :number_target_z,
    #                           'TargetOrganizationName' => :name, 'SubjectName' => :subject_name, 'SubjectID' => :use_subject_id, 'Form' => :form,
    #                           'EntranceTestItems' => :test_items_attributes, 'MinScore' => :min_score, 'EntranceTestPriority' => :entrance_test_priority,
    #                           'CommonBenefit' => :common_benefits_attributes, 'EntranceTestBenefits' => :benefit_items_attributes, 'BenefitKindID' => :benefit_kind_id,
    #                           'IsForAllOlympics' => :is_for_all_olympics, 'OlympicDiplomTypes' => :diplom_types_attributes, 'OlympicDiplomTypeID' => :olympic_diplom_type_id,
    #                           'OlympicYear' => :year
    #                   })
    # keepers = [:campaign_id, :id, :course, :name, :items_attributes, :target_organizations_attributes, :test_items_attributes, :common_benefits_attributes]
    # ti_keepers = [:subject_name, :use_subject_id, :form, :min_score, :entrance_test_priority, :benefit_items_attributes]
    # cb_keepers = [:benefit_kind_id, :is_for_all_olympics, :diplom_types_attributes, :year]
    # hash.first.second[:competitive_group].each do |cg|
    #   if cg[:target_organizations_attributes].nil?
    #     cg[:target_organizations_attributes] = []
    #   else
    #     cg[:target_organizations_attributes] = cg[:target_organizations_attributes]['TargetOrganization']
    #     if cg[:target_organizations_attributes].length > 1 and !cg[:target_organizations_attributes].is_a?(::Hash)
    #       cg[:target_organizations_attributes].each do |to|
    #         to[:items_attributes] = to[:items_attributes]['CompetitiveGroupTargetItem']
    #         to[:items_attributes] = [to[:items_attributes]] if to[:items_attributes].is_a?(::Hash)
    #       end
    #     else
    #       cg[:target_organizations_attributes][:items_attributes] = cg[:target_organizations_attributes][:items_attributes]['CompetitiveGroupTargetItem']
    #       cg[:target_organizations_attributes] = [cg[:target_organizations_attributes]]
    #     end
    #   end
    #   if cg[:test_items_attributes].nil?
    #     cg[:test_items_attributes] = []
    #   else
    #     cg[:test_items_attributes] = cg[:test_items_attributes]['EntranceTestItem']
    #     if cg[:test_items_attributes].length > 1 and !cg[:test_items_attributes].is_a?(::Hash)
    #       cg[:test_items_attributes].each do |ti|
    #         ti.merge!(ti['EntranceTestSubject'])
    #         ti.keep_if{|k,_| ti_keepers.include? k }
    #         if ti[:benefit_items_attributes].nil?
    #           ti[:benefit_items_attributes] = []
    #         else
    #           ti[:benefit_items_attributes] = ti[:benefit_items_attributes]['EntranceTestBenefitItem']
    #           if ti[:benefit_items_attributes].length > 1 and !ti[:benefit_items_attributes].is_a?(::Hash)
    #             ti[:benefit_items_attributes].each do |cb|
    #               cb[:diplom_types_attributes] = [{olympic_diplom_type_id: 1}, {olympic_diplom_type_id: 2}]
    #               cb.keep_if{|k,_| cb_keepers.include? k }
    #             end
    #           else
    #             ti[:benefit_items_attributes][:diplom_types_attributes] = [{olympic_diplom_type_id: 1}, {olympic_diplom_type_id: 2}]
    #             ti[:benefit_items_attributes].keep_if{|k,_| cb_keepers.include? k }
    #             ti[:benefit_items_attributes] = [ti[:benefit_items_attributes]]
    #           end
    #         end
    #       end
    #     else
    #       cg[:test_items_attributes].merge!(cg[:test_items_attributes]['EntranceTestSubject'])
    #       cg[:test_items_attributes].keep_if{|k,_| ti_keepers.include? k }
    #       if cg[:test_items_attributes][:benefit_items_attributes].nil?
    #         cg[:test_items_attributes][:benefit_items_attributes] = []
    #       else
    #         cg[:test_items_attributes][:benefit_items_attributes] = cg[:test_items_attributes][:benefit_items_attributes]['EntranceTestBenefitItem']
    #         if cg[:test_items_attributes][:benefit_items_attributes].length > 1 and !cg[:test_items_attributes][:benefit_items_attributes].is_a?(::Hash)
    #           cg[:test_items_attributes][:benefit_items_attributes].each do |cb|
    #             cb[:diplom_types_attributes] = [{olympic_diplom_type_id: 1}, {olympic_diplom_type_id: 2}]
    #             cb.keep_if{|k,_| cb_keepers.include? k }
    #           end
    #         else
    #           cg[:test_items_attributes][:benefit_items_attributes][:diplom_types_attributes] = [{olympic_diplom_type_id: 1}, {olympic_diplom_type_id: 2}]
    #           cg[:test_items_attributes][:benefit_items_attributes].keep_if{|k,_| cb_keepers.include? k }
    #           cg[:test_items_attributes][:benefit_items_attributes] = [cg[:test_items_attributes][:benefit_items_attributes]]
    #         end
    #       end
    #       cg[:test_items_attributes] = [cg[:test_items_attributes]]
    #     end
    #   end
    #   if cg[:common_benefits_attributes].nil?
    #     cg[:common_benefits_attributes] = []
    #   else
    #     cg[:common_benefits_attributes] = cg[:common_benefits_attributes]['CommonBenefitItem']
    #     if cg[:common_benefits_attributes].length > 1 and !cg[:common_benefits_attributes].is_a?(::Hash)
    #       cg[:common_benefits_attributes].each do |cb|
    #         cb[:diplom_types_attributes] = [{olympic_diplom_type_id: 1}, {olympic_diplom_type_id: 2}]
    #         cb.keep_if{|k,_| cb_keepers.include? k }
    #       end
    #     else
    #       cg[:common_benefits_attributes][:diplom_types_attributes] = [{olympic_diplom_type_id: 1}, {olympic_diplom_type_id: 2}]
    #       cg[:common_benefits_attributes].keep_if{|k,_| cb_keepers.include? k }
    #       cg[:common_benefits_attributes] = [cg[:common_benefits_attributes]]
    #     end
    #   end
    #   cg.keep_if{|k,_| keepers.include? k }
    #   # raise cg.inspect unless cg[:common_benefits_attributes].empty?
    #   Entrance::CompetitiveGroup.create cg
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

  def nested_hash_value(hash,key)
    if hash.respond_to?(:key?) && obj.key?(key)
      hash[key]
    elsif hash.respond_to?(:each)
      r = nil
      hash.find{ |*a| r=nested_hash_value(a.last,key) }
      r
    end
  end
end