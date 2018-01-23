class NewsController < ApplicationController

  skip_before_action :authorize, only: [:show]

  def index
    # page = params[:page].nil? ? 0 : params[:page].to_i 
    # limit = params[:limit].nil? ? 10 : params[:limit].to_i

    @news = News.where("jail_id = #{session[:jail_id]}")#.limit(limit).offset(page * limit)
    @total = News.where(jail_id: session[:jail_id]).size

    respond_to do |format|
      format.html
      format.json { render json: { total: @total, news: @news } }
    end
  end

  def create
    @news = News.new(news_params)
    @news.save
    redirect_to news_index_path
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

    if @news.update_attributes(news_params)
      redirect_to news_index_path
    else
      render 'edit'
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
    redirect_to news_index_path
  end


  private 
  
  def news_params
    params.require(:news).permit(:title, 
                                 :contents, 
                                 :jail_id, 
                                 :image, 
                                 :type_id, 
                                 :is_focus,
                                 :sys_flag)
  end
    
end
