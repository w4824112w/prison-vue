#encoding = utf-8

class OrdersController < ApplicationController
  
  def index
    page = params[:page] ? params[:page].to_i : 0;
    limit = params[:limit] ? params[:limit].to_i : 10;

    @items_orders = Order.success_orders(session[:jail_id], limit, limit * page)

    respond_to do |format|
      format.html
      format.json { render json: { orders: @items_orders } }
    end
  end

  def show
    @order = Order.find(params[:id])
    @prisoner = @order.family.prisoner

    respond_to do |format|
      if @order.jail_id == session[:jail_id]
        format.html
        format.json { render json: { 
          trade_no: @order.trade_no,
          line_items: @order.line_items.map { |li| { title: li.item.title, quantity: li.quantity, price: li.item.price } },
          payment_time: @order.gmt_payment,
          amount: @order.amount,
          status: @order.status,
          prisoner: { name: @prisoner.name, area: @prisoner.prison_area }
          } }
      else
        format.html { raise ActionController::RoutingError.new('Not Found') }
        format.json { render json: {} }
      end
    end

  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(status: params[:order][:status])
      render json: { error: 0 }
      return
    end

    render json: { error: 500, msg: '订单状态更新失败' }
  end

end
