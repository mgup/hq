class University < ActiveRecord::Base
  has_many :reviews, foreign_key: :university_id
  has_many :reviews_author, class_name: 'Review', foreign_key: :university_auth_id

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |university|
        csv << university.attributes.values_at(*column_names)
      end
    end
  end
end
