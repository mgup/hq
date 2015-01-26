class Finance::PaymentType < ActiveRecord::Base
  self.table_name = 'finance_payment_type'

  alias_attribute :id,          :finance_payment_type_id
  alias_attribute :year,        :finance_payment_type_year
  alias_attribute :form,        :finance_payment_type_form

  has_many :prices, class_name: Finance::Price, primary_key: :finance_payment_type_id,
           foreign_key: :finance_price_payment_type
  belongs_to :speciality, class_name: Speciality, primary_key: :speciality_id, foreign_key: :finance_payment_type_speciality

  scope :from_faculty, -> faculty {where(finance_payment_type_speciality: Department.find(faculty).specialities.collect{|s| s.id})}
  scope :from_speciality, -> speciality {where(finance_payment_type_speciality: speciality)}
  scope :from_speciality_name, -> name { joins(:speciality).where('speciality.speciality_name LIKE :prefix OR speciality.speciality_code LIKE :prefix', prefix: "%#{name}%")                                            .includes(:speciality)}
  scope :from_year, -> year {where(finance_payment_type_year: year)}
  scope :from_form, -> form {where(finance_payment_type_form: form)}

  scope :with_prices, -> {joins(:prices)}

  acts_as_xlsx

  default_scope do
   includes(:speciality, :prices)
    .order(:finance_payment_type_speciality, :finance_payment_type_year)
  end

  scope :my_filter, -> filters {
    [:speciality, :faculty, :year, :form].inject(all) do |cond, field|
      if filters.include?(field) && !filters[field].empty?
        cond = cond.send "from_#{field.to_s}", filters[field]
      end
      cond
    end
  }

  def faculty
    speciality.faculty.abbreviation
  end

  def sum
    total_sum = 0
    {
        by_year: prices.inject(Hash.new(0)) do |by_year, price|
          by_year[price.year.to_s] += price.sum
          total_sum += price.sum
          by_year
        end,
        total: total_sum
    }
  end

  def form_of_study
    case form
      when 101
        'очная'
      when 102
        'очно-заочная'
      when 103
        'заочная'
      when 105
        'дистанционная'
    end
  end

end