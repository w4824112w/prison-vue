class PrisonerOrdersController < ApplicationController
  def index
    @prisoner_orders_table_content = PrisonerOrder.list(session[:jail_id], params[:length], params[:start])

    respond_to do |format|
      format.html
      format.json { render json: { draw: params[:draw],
                                   recordsFiltered: @prisoner_orders_table_content[:total],
                                   recordsTotal: @prisoner_orders_table_content[:total],
                                   data: { prisoner_order_details_data: @prisoner_orders_table_content[:prisoner_order_details],
                                           prisoner_orders_data: @prisoner_orders_table_content[:prisoner_orders] }
                                   } }
    end
  end

  def import_index
    render 'import'
  end

  def upload
    @import_result=PrisonerOrder.upload(params[:file])
    render json: @import_result
  end

  def import
    @import_result=PrisonerOrder.import(params[:filepath],session[:jail_id])
    render json: @import_result
  end
end
