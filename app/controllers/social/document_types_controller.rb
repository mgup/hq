class Social::DocumentTypesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @document_type.save
      redirect_to social_document_types_path, notice: 'Создан новый тип документов.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @document_type.update(resource_params)
      redirect_to social_document_types_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:social_document_type, {}).permit(:name)
  end
end