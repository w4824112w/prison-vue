class TerminalsController < ApplicationController
 # skip_before_action :authorize
 before_action :authenticate!
 
  def show_index
    render 'import'
  end

  def index
    @terminals_table_content = Terminal.list(params[:jail_id], params[:length], params[:start])
    render json: { draw: params[:draw],
                                     recordsFiltered: @terminals_table_content[:total],
                                     recordsTotal: @terminals_table_content[:total],
                                     data: {  prisoner_data: @terminals_table_content[:terminals] }
                                     } 
  #  respond_to do |format|
  #    format.html
  #    format.json { render json: { draw: params[:draw],
  #                                 recordsFiltered: @terminals_table_content[:total],
  #                                 recordsTotal: @terminals_table_content[:total],
  #                                 data: {  prisoner_data: @terminals_table_content[:terminals] }
  #                                 } 
  #                }
  #  end
  end

  def create
    @terminal = Terminal.new(terminal_params)
    if @terminal.save
    #  render 'index'
      return render json: { code: 200, msg: "数据更新成功！" }
    else
    #  render 'new'
      return render json: { code: 500, msg: "请核对数据是否正确！" }
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
    #  render 'index'
      return render json: { code: 200, msg: "数据更新成功！" }
    else
    #  render 'edit'
      return render json: { code: 500, msg: "请核对数据是否正确！" }
    end
  end

  def terminal_params
    params.permit(:jail_id, 
                                 :terminal_number, 
                                 :room_number, 
                                 :host_password, 
                                 :metting_password)
  end

end
