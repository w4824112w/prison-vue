class NewsController < ApplicationController
  before_action :authenticate!

#  skip_before_action :authorize, only: [:show]

  def index
    # page = params[:page].nil? ? 0 : params[:page].to_i 
    # limit = params[:limit].nil? ? 10 : params[:limit].to_i

    @news = News.where("jail_id = #{params[:jail_id]}")#.limit(limit).offset(page * limit)
    @total = News.where(jail_id: params[:jail_id]).size
    render json: { total: @total, news: @news }
  #  respond_to do |format|
  #    format.html
  #    format.json { render json: { total: @total, news: @news } }
  #  end
  end

  def create
  #  @news = News.new(news_params)
  #  @news.save
  #  redirect_to news_index_path

    @upload_result=News.upload(params[:image])
    if @upload_result[:code] == 200
      @news = News.new({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], type_id: params[:type_id], is_focus: params[:is_focus], sys_flag: params[:sys_flag],image_file_name: @upload_result[:name], image_url: @upload_result[:path], image_content_type: @upload_result[:content_type] })
    else
      @news = News.new({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], type_id: params[:type_id], is_focus: params[:is_focus], sys_flag: params[:sys_flag] })
    end  
    
  	if @news.save
      return render json: { code: 200, msg: "数据新增成功！" }
    else
      return render json: { code: 500, msg: "请核对数据是否正确！" }
  	end

  end

  def new
    @news = News.new
  end 

  def edit
    @news = News.find_by_id(params[:id])
  end

  def update
    @news = News.find(params[:id])
    @news.contents.html_safe

  #  if @news.update_attributes(news_params)
  #    redirect_to news_index_path
  #  else
  #    render 'edit'
  #  end

    @upload_result=News.upload(params[:image])
    if @upload_result[:code] == 200
      if @news.update_attributes({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], type_id: params[:type_id], is_focus: params[:is_focus], sys_flag: params[:sys_flag],image_file_name: @upload_result[:name], image_url: @upload_result[:path], image_content_type: @upload_result[:content_type] })
        return render json: { code: 200, msg: "数据更新成功！" }
      else
        return render json: { code: 500, msg: "请核对数据是否正确！" }
      end
    else
      if @news.update_attributes({title: params[:title], contents: params[:contents], jail_id: params[:jail_id], type_id: params[:type_id], is_focus: params[:is_focus], sys_flag: params[:sys_flag] })
        return render json: { code: 200, msg: "数据更新成功！" }
      else
        return render json: { code: 500, msg: "请核对数据是否正确！" }
      end
    end

  end

  def show
    @new = News.find_by_id(params[:id])
    render action: "show", layout: "show"
  end

  
  def destroy
    @news = News.find(params[:id])
    # @news.destroy
    @news.update_attributes(:sys_flag => 0)
    return render json: { code: 200, msg: "数据更新成功！" }
   # redirect_to news_index_path
  end


#  private 
  
#  def news_params
#    params.permit(:title, 
#                                 :contents, 
#                                 :jail_id, 
#                                 :image, 
#                                 :type_id, 
#                                 :is_focus,
#                                 :sys_flag)
#  end
    
end
