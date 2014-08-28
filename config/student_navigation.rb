SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.dom_class = 'nav nav-tabs'
    if can? :read, Student
      primary.item :person, 'Персональные данные'.html_safe, student_path(@student)
      primary.item :study,  'Учёба'.html_safe, student_study_path(@student)
    end
    if can? :read, Hostel
      primary.item :hostel, 'Общежитие'.html_safe, student_hostel_path(@student)
    end
    if can? :read, Office::Order
      primary.item :orders, 'Приказы'.html_safe, student_orders_path(@student)
    end
    if can? :manage, Document::Doc
      primary.item :documents, 'Документы'.html_safe, student_documents_path(@student)
    end
    if can? :manage, Social::Document
      primary.item :grants, 'ЦСПиВР'.html_safe, student_social_deeds_path(@student)
    end
  end
end