class PrisonerOrdersController < ApplicationController
  before_action :authenticate!

  def index
    @prisoner_orders_table_content = PrisonerOrder.list(params[:jail_id], params[:length], params[:start])

    render json: { draw: params[:draw],
                                     recordsFiltered: @prisoner_orders_table_content[:total],
                                     recordsTotal: @prisoner_orders_table_content[:total],
                                     data: { prisoner_order_details_data: @prisoner_orders_table_content[:prisoner_order_details],
                                             prisoner_orders_data: @prisoner_orders_table_content[:prisoner_orders] }
                                     }
  #  respond_to do |format|
  #    format.html
  #    format.json { render json: { draw: params[:draw],
  #                                 recordsFiltered: @prisoner_orders_table_content[:total],
  #                                 recordsTotal: @prisoner_orders_table_content[:total],
  #                                 data: { prisoner_order_details_data: @prisoner_orders_table_content[:prisoner_order_details],
  #                                         prisoner_orders_data: @prisoner_orders_table_content[:prisoner_orders] }
  #                                 } }
  #  end
  end

  def import_index
    render 'import'
  end

  def upload
    @import_result=PrisonerOrder.upload(params[:file])
    render json: @import_result
  end

  def import
    @import_result=PrisonerOrder.import(params[:filepath],params[:jail_id])
    render json: @import_result
  end
end
