# Тип документа, удостоверяющего личность.
class IdentityDocumentType < ActiveRecord::Base
  has_many :entrants, class_name: 'Entrance::Entrant'
end
