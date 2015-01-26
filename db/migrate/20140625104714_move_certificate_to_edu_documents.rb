class MoveCertificateToEduDocuments < ActiveRecord::Migration
  def up
    execute <<-SQL
INSERT INTO entrance_edu_documents
	(entrant_id, number, date, organization, graduation_year, foreign_institution)
SELECT
	entrance_entrants.id,
	entrance_entrants.certificate_number,
	entrance_entrants.certificate_date,
	entrance_entrants.institution,
	entrance_entrants.graduation_year,
	entrance_entrants.foreign_institution
FROM entrance_entrants;
    SQL
  end
end
