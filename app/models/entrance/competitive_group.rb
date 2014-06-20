class Entrance::CompetitiveGroup < ActiveRecord::Base

  has_many :items, class_name: 'Entrance::CompetitiveGroupItem'
  accepts_nested_attributes_for :items

  has_many :target_organizations, class_name: 'Entrance::TargetOrganization'
  accepts_nested_attributes_for :target_organizations

  has_many :test_items, class_name: 'Entrance::TestItem'
  accepts_nested_attributes_for :test_items

  has_many :common_benefits, class_name: 'Entrance::CommonBenefitItem'
  accepts_nested_attributes_for :common_benefits

  belongs_to :campaign, class_name: 'Entrance::Campaign'

  def items_attributes=(attributes)
    attributes.each do |item_hash|
      item = item_hash.second
      unless self.items.collect{|i| i.id}.include? item['id']
        self.items << Entrance::CompetitiveGroupItem.create(item.merge(competitive_group_id: self.id))
      end
    end
    super
  end

end