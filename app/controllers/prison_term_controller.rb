class PrisonTermController < ApplicationController
  before_action :authenticate!

  def import_index
    render 'import'
  end

  def upload
    @import_result=PrisonTerm.upload(params[:file])
    render json: @import_result
  end

  def import
    @import_result=PrisonTerm.import(params[:filepath],params[:jail_id])
    render json: @import_result
  end
end
