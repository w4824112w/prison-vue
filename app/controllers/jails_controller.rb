class JailsController < ApplicationController
#  skip_before_action :authorize, only: [:show] 
before_action :authenticate!

  def index
  	@jail = Jail.find_by_id(params[:jail_id])

    render json: @jail
  #	respond_to do |format|
  #    format.html
  #    format.json { render json: @jail }
  #  end
  end

  def edit
  	@jail = Jail.find(params[:id])
  end

  def update
    @jail = Jail.find(params[:jail_id])
  #  @imgFile = params[:image]
  #  puts @imgFile.inspect
  #  puts 'params--'+params.inspect
    @upload_result=Jail.upload(params[:image])
  #  puts @upload_result
    if @upload_result[:code] == 200
    #  puts 'update img....................'
      if @jail.update_attributes({zipcode: params[:zipcode], title: params[:title], description: params[:description], street: params[:street], district: params[:district], city: params[:city], state: params[:state],image_file_name: @upload_result[:name], image_url: @upload_result[:path], image_content_type: @upload_result[:content_type] })
        return render json: { code: 200, msg: "数据更新成功！" }
      else
        return render json: { code: 500, msg: "请核对数据是否正确！" }
      end
    else
    #  puts 'update no img....................'
      if @jail.update_attributes({zipcode: params[:zipcode], title: params[:title], description: params[:description], street: params[:street], district: params[:district], city: params[:city], state: params[:state] })
        return render json: { code: 200, msg: "数据更新成功！" }
      else
        return render json: { code: 500, msg: "请核对数据是否正确！" }
      end
    end

  end

  def show
    @jail = Jail.find(params[:id])
    render action: 'show', layout: 'show'
  end

#  private

#  def jails_params
#    params.permit(:id, :zipcode, :title, :description, :street, :district, :city, :state, :image)
#  end

end
