class FamiliesController < ApplicationController

  def index
    @families_table_content = Family.list(session[:jail_id], params[:length], params[:start])

    respond_to do |format|
      format.html
      format.json { render json: { draw: params[:draw],
                                   recordsFiltered: @families_table_content[:total],
                                   recordsTotal: @families_table_content[:total],
                                   data: { families_data: @families_table_content[:families],
                                     prisoners_data: @families_table_content[:prisoners] }
                                  }}
    end
  end

end
