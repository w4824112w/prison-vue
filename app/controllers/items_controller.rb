class ItemsController < ApplicationController
  #before_filter :test
  before_action :authenticate!

  def index
    @items = Item.where(jail_id: params[:jail_id],sys_flag: 1)
    @items.each { |i| i.avatar_url = i.avatar.url(:thumb) }

    render json: @items
  #  respond_to do |format|
  #    format.html
  #    format.json { render json: @items }
  #  end
  end

  def new
    @item = Item.new()
  end

  def create
    @item = Item.create(item_params)
    if @item.save
     # redirect_to items_path
     return render json: { code: 200, msg: "数据新增成功！" }
    else
    #  render 'new'
      return render json: { code: 500, msg: "请核对数据是否正确！" }
    end
  end

  def edit
    @item = Item.find(params[:id])
    render json: @item
  end

  def update
    puts '11111111111111111111111111111'
   # puts params[:avatar].inspect
   puts params[:id]
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      return render json: { code: 200, msg: "数据更新成功！" }
    #  redirect_to items_path
    else
      return render json: { code: 500, msg: "请核对数据是否正确！" }
    #  render 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    # @item.destroy
    @item.update_attributes(:sys_flag => 0)
  #  redirect_to items_path
    return render json: { code: 200, msg: "数据删除成功！" }
  end

  private

  def item_params
    params.permit(:id, :title, 
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
