module SpecialityHelper
  def speciality_type(speciality = @speciality)
    speciality.type == 0 ? 'специальность' : 'направление'
  end
end