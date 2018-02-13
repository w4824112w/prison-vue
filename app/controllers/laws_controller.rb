class LawsController < ApplicationController
  before_action :authenticate!
#  skip_before_action :authorize, only: [:show]

  def index
    @laws = Law.where('jail_id =?', params[:jail_id])
    
    render json: @laws
  #  respond_to do |format|
  #    format.html
  #    format.json { render json: @laws }
  #  end
  end

  def new
  	@law = Law.new
  end

  def create
    @upload_result=Law.upload(params[:image])
  #	@law = Law.new(laws_params)
 # update_attributes({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], sys_flag: params[:sys_flag], image_file_name: @upload_result[:name], image_url: @upload_result[:path], image_content_type: @upload_result[:content_type] })
    if @upload_result[:code] == 200
      @law = Law.new({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], sys_flag: params[:sys_flag], image_file_name: @upload_result[:name], image_url: @upload_result[:path], image_content_type: @upload_result[:content_type] })
    else
      @law = Law.new({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], sys_flag: params[:sys_flag] })
    end  
    
    puts 'ok.....................................'
    puts @law.inspect
  	if @law.save
  	#	redirect_to laws_path
    #  return
      return render json: { code: 200, msg: "数据新增成功！" }
    else
      return render json: { code: 500, msg: "请核对数据是否正确！" }
  	end
  	#redirect_to new_law_path
  end

  def edit
  	@law = Law.find(params[:id])
  end

  def update
    @law = Law.find(params[:id])
    @upload_result=Law.upload(params[:image])

    if @upload_result[:code] == 200
      #  puts 'update img....................'
        if @law.update_attributes({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], sys_flag: params[:sys_flag], image_file_name: @upload_result[:name], image_url: @upload_result[:path], image_content_type: @upload_result[:content_type] })
          return render json: { code: 200, msg: "数据更新成功！" }
        else
          return render json: { code: 500, msg: "请核对数据是否正确！" }
        end
      else
      #  puts 'update no img....................'
        if @law.update_attributes({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], sys_flag: params[:sys_flag] })
          return render json: { code: 200, msg: "数据更新成功！" }
        else
          return render json: { code: 500, msg: "请核对数据是否正确！" }
        end
      end

  #	if @law.update(laws_params)
  	#	redirect_to laws_path
 #     return
 # 	end
  	
  #  redirect_to edit_law_path
  end

  def destroy
    @law = Law.find(params[:id])
    #@law.destroy
    @law.update_attributes(:sys_flag => 0)
    return render json: { code: 200, msg: "数据更新成功！" }
  end

  def show
    @law = Law.find_by_id(params[:id])
    render action: "show", layout: "show"
  end

#  private

#	def laws_params
#	  params.require(:law).permit(:title, :contents, :jail_id, :image,:sys_flag)
#	end

end
