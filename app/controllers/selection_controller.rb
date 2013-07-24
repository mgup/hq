class SelectionController < ApplicationController

  def index

  end

  def contract
    @documents = Document::Doc.all

    @students = []
    Student.paid.entrants.each do |student|
      p = Finance::PaymentType.from_student(student).where(finance_payment_type_year: 2013).first
      cost = Finance::Price.where(finance_price_payment_type: p).collect{ |p| p.price * 2}
      doc = student.documents.where(document_type: 5).first.number  if student.documents.where(document_type: 5).first != nil
      if doc
        payer = student.documents.where(document_type: 5).first.metas.where(document_meta_pattern: 'Плательщик').first.text
      end

      @students << { student: student, cost: cost, document: doc, payer: payer}
    end
  end

end