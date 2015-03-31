class University < ActiveRecord::Base
  has_many :reviews
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |university|
        csv << university.attributes.values_at(*column_names)
      end
    end
  end
end
