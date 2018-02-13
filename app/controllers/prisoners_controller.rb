class PrisonersController < ApplicationController
  before_action :authenticate!

  def index
    @prisoners_table_content = Prisoner.list(params[:jail_id], params[:length], params[:start])
    render json: { draw: params[:draw],
                                     recordsFiltered: @prisoners_table_content[:total],
                                     recordsTotal: @prisoners_table_content[:total],
                                     data: { families_data: @prisoners_table_content[:families],
                                             prisoner_data: @prisoners_table_content[:prisoners] }
                                     }
  #  respond_to do |format|
  #    format.html
  #    format.json { render json: { draw: params[:draw],
  #                                 recordsFiltered: @prisoners_table_content[:total],
  #                                 recordsTotal: @prisoners_table_content[:total],
  #                                 data: { families_data: @prisoners_table_content[:families],
  #                                         prisoner_data: @prisoners_table_content[:prisoners] }
  #                                 } }
  #  end
  end

  def import_index
    render 'import'
  end

  def upload
    @import_result=Prisoner.upload(params[:file])
    render json: @import_result
  end

  def import
    @import_result=Prisoner.import(params[:filepath],params[:jail_id])
    render json: @import_result
  end

  def upload_img
    @import_result=Prisoner.upload_img(params[:imgFile])
    render json: @import_result
  end

  def del_img
    @import_result=Prisoner.del_img(params[:imgsArr])
    render json: @import_result
  end 
end
