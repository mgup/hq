SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.dom_class = 'nav nav-tabs'
    primary.item :person, 'Персональные данные'.html_safe, student_path(@student)
    primary.item :study,  'Учёба'.html_safe, student_study_path(@student)
    primary.item :hostel, 'Общежитие'.html_safe, student_hostel_path(@student)
    primary.item :orders, 'Приказы'.html_safe, student_orders_path(@student)
    primary.item :documents, 'Документы'.html_safe, student_documents_path(@student)
    primary.item :grants, 'ЦСПиВР'.html_safe, student_grants_path(@student)
  end
end