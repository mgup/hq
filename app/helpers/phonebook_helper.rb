module PhonebookHelper
  def workphone_present(position)
    if position.user.workphone.present?
      position.user.workphone
    else
      position.department.phone
    end
  end
end
