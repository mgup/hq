class AddAddressFieldsToStudentGroup < ActiveRecord::Migration
  def change
    change_table(:student) do |t|
      t.string  :registration_country_name
      t.integer :registration_country_code
      t.string  :registration_region_name
      t.integer :registration_region_code
      t.string  :registration_district_name
      t.integer :registration_district_code
      t.string  :registration_city_name
      t.integer :registration_city_code
      t.string  :registration_city_area_name
      t.integer :registration_city_area_code
      t.string  :registration_place_name
      t.integer :registration_place_code
      t.string  :registration_street_name
      t.integer :registration_street_code
      t.string  :registration_extra_name
      t.integer :registration_extra_code
      t.string  :registration_child_extra_name
      t.integer :registration_child_extra_code
      t.string  :registration_house
      t.string  :registration_building
      t.string  :registration_corp
      t.string  :registration_flat
      
      t.string  :residence_country_name
      t.integer :residence_country_code
      t.string  :residence_region_name
      t.integer :residence_region_code
      t.string  :residence_district_name
      t.integer :residence_district_code
      t.string  :residence_city_name
      t.integer :residence_city_code
      t.string  :residence_city_area_name
      t.integer :residence_city_area_code
      t.string  :residence_place_name
      t.integer :residence_place_code
      t.string  :residence_street_name
      t.integer :residence_street_code
      t.string  :residence_extra_name
      t.integer :residence_extra_code
      t.string  :residence_child_extra_name
      t.integer :residence_child_extra_code
      t.string  :residence_house
      t.string  :residence_building
      t.string  :residence_corp
      t.string  :residence_flat
    end
  end
end
