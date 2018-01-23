class VersionsController < ApplicationController

  def index
    @versions_table_content = Version.list(params[:length], params[:start])

    respond_to do |format|
      format.html
      format.json { render json: { draw: params[:draw],
                                   recordsFiltered: @versions_table_content[:total],
                                   recordsTotal: @versions_table_content[:total],
                                   data: {  prisoner_data: @versions_table_content[:versions] }
                                   } 
                  }
    end
  end

  def edit
    @version = Version.find(params[:id])
    render json: {data: @version}
  end

  def update
    @version = Version.find(params[:id])
    
    if @version.update_attributes(versions_params)
      return render json: { code: 200, msg: "数据更新成功！" }
    else
      return render json: { code: 500, msg: "请核对数据是否正确！" }
    end

  end

  def versions_params
    #params.require(:version).permit(:version_code, :version_number, :is_force)
    params.permit(:version_code, :version_number, :is_force)
  end

end
