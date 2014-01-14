class BlanksController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show
  end

  def new

  end

  def edit
  end

  def create
    respond_to do |format|
      if @blank.save
        format.html { redirect_to @blank, notice: 'Blank was successfully created.' }
        format.json { render action: 'show', status: :created, location: @blank }
      else
        format.html { render action: 'new' }
        format.json { render json: @blank.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @blank.update(resource_params)
        format.html { redirect_to @blank, notice: 'Blank was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @blank.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @blank.destroy
    respond_to do |format|
      format.html { redirect_to blanks_url }
      format.json { head :no_content }
    end
  end

  def resource_params
    params.require(:blank).permit(:type, :number, :details)
  end
end
