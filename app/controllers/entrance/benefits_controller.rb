class Entrance::BenefitsController < ApplicationController
  load_and_authorize_resource :campaign, class: Entrance::Campaign
  load_and_authorize_resource :entrant, class: Entrance::Entrant
  load_and_authorize_resource :benefit, class: Entrance::Benefit, except: [:index]

  def index
    @benefits = Entrance::Entrant.unscoped.find(params[:entrant_id]).applications.collect{|a| a.benefits}.flatten
  end

  def new
    @benefit.build_custom_document
    @benefit.build_orphan_document
    @benefit.build_olympic_document
    @benefit.build_olympic_total_document
    @benefit.build_medical_disability_document
    @benefit.build_allow_education_document
  end

  def create
    @benefit.save
    redirect_to entrance_campaign_entrant_benefits_path(@campaign, @entrant)
  end

  def update
    if @benefit.update(resource_params)
      redirect_to entrance_campaign_entrant_benefits_path(@campaign, @entrant)
    end
  end

  def destroy
    @benefit.destroy
    redirect_to entrance_campaign_entrant_benefits_path(@campaign, @entrant)
  end

  def resource_params
    params.fetch(:entrance_benefit, {}).permit( :application_id, :benefit_kind_id,
          :document_type_id, :temp_text,
           custom_document_attributes: [:id, :original, :series, :number, :date,
                                        :organization, :additional_info, :type_name],
           orphan_document_attributes: [:id, :series, :number, :date, :orphan_category_id,
                                       :organization, :additional_info, :type_name],
           olympic_document_attributes: [:id, :original, :series, :number, :date,
                                         :diploma_type_id, :olympic_id, :level_id, :class_number,
                                         :profile_id],
           olympic_total_document_attributes: [:id, :original, :series, :number,
                                               :diploma_type_id],
           medical_disability_document_attributes: [:id, :original, :series, :number, :date,
                                                    :organization, :disability_type_id, :kind],
           allow_education_document_attributes: [:id, :original, :number, :date, :organization ]
    )
  end

end
