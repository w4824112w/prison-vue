class ItemsController < ApplicationController
  #before_filter :test

  def index
    @items = Item.where(jail_id: session[:jail_id],sys_flag: 1)
    @items.each { |i| i.avatar_url = i.avatar.url(:thumb) }

    respond_to do |format|
      format.html
      format.json { render json: @items }
    end
  end

  def new
    @item = Item.new()
  end

  def create
    @item = Item.create(item_params)
    if @item.save
      redirect_to items_path
    else
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      redirect_to items_path
    else
      render 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    # @item.destroy
    @item.update_attributes(:sys_flag => 0)
    redirect_to items_path
  end

  private

  def item_params
    params.require(:item).permit(:title, 
                                 :description, 
                                 :price, 
                                 :avatar, 
                                 :jail_id, 
                                 :category_id,
                                 :unit, 
                                 :factory, 
                                 :barcode, 
                                 :ranking,
                                 :sys_flag)
  end

end
