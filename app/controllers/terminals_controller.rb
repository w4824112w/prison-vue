class TerminalsController < ApplicationController
  skip_before_action :authorize

  def show_index
    render 'import'
  end

  def index
    @terminals_table_content = Terminal.list(session[:jail_id], params[:length], params[:start])

    respond_to do |format|
      format.html
      format.json { render json: { draw: params[:draw],
                                   recordsFiltered: @terminals_table_content[:total],
                                   recordsTotal: @terminals_table_content[:total],
                                   data: {  prisoner_data: @terminals_table_content[:terminals] }
                                   } 
                  }
    end
  end

  def create
    @terminal = Terminal.new(terminal_params)
    if @terminal.save
      render 'index'
    else
      render 'new'
    end
  end

  def new
    @terminal = Terminal.new
  end 

  def edit
    @terminal = Terminal.find_by_id(params[:id])
  end

  def update
    @terminal = Terminal.find(params[:id])
    if @terminal.update_attributes(terminal_params)
      render 'index'
    else
      render 'edit'
    end
  end

  def terminal_params
    params.require(:terminal).permit(:jail_id, 
                                 :terminal_number, 
                                 :room_number, 
                                 :host_password, 
                                 :metting_password)
  end

end
