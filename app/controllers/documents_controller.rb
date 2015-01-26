class DocumentsController < ApplicationController

  def calloz
    @group = Group.find(params[:group]) if params[:group]
    respond_to do |format|
      format.html do
        @faculties = Department.faculties
        unless current_user.is?(:developer)
          user_departments = current_user.departments_ids
          @faculties = @faculties.find_all { |f| user_departments.include?(f.id) }
        end
      end
      format.pdf do
        @typecall = case params[:typecall]
                    when '1' then 'прохождения вступительных испытаний'
                    when '2' then 'промежуточной аттестации'
                    when '3' then 'государственной итоговой аттестации'
                    when '4' then 'итоговой аттестации'
                    when '5' then 'подготовки и защиты выпускной квалификационной работы и/или сдачи итоговых государственных экзаменов'
                    when '6' then 'завершения диссертации на соискание ученой степени кандидата наук'
                    end
        @from = params[:from]
        @to = params[:to]
      end
    end
  end

end