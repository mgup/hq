class SelectionController < ApplicationController

  def index

  end

  def contract
    @documents = Document::Doc.all

    @students = []
    Student.paid.entrants.each do |student|
      p = Finance::PaymentType.from_student(student).where(finance_payment_type_year: 2013).first
      cost = Finance::Price.where(finance_price_payment_type: p).collect{ |p| p.price * 2}
      document = student.documents.where(document_type: 5).first
      if document != nil
        doc = document.number
        date = document.date.strftime("%d.%m.%Y")
      end

      if doc
        payer = student.documents.where(document_type: 5).first.metas.where(document_meta_pattern: 'Плательщик').first.text
      end

      @students << { student: student, cost: cost, document: doc, payer: payer, date: date}
    end
  end

end