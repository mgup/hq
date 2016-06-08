# Документ, удостоверяющий личность.
class IdentityDocument < ActiveRecord::Base
 belongs_to :entrant, class_name: 'Entrance::Entrant', foreign_key: :entrance_entrant_id
 belongs_to :identity_document_type, class_name: 'IdentityDocumentType'
end
