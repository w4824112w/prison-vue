module Api
  module V1
    class OrdersController < ApiController

      def create
        order = Order.new(order_params)

        # set order's default status
        order.status= 'WAIT_FOR_PAYMENT'

        if order.save
          render json: { code: 200, order: order }
          return
        end

        render json: { code: 500, msg: 'Create order failed', errors: order.errors }
      end

      # WeiXin and UNION payment platforms require a prepay id.
      # 
      # @param params[Hash]
      # @return [Hash] 
      def prepay
        order = Order.find_by_trade_no(params[:trade_no])

        if order
          render json: order.prepay(params[:payment_type])
          return
        end

        render json: { code: 500, msg: "Can not found order: #{params[:trade_no]}" }
      end

      def update_order_status
        order = Order.find_by_trade_no(params[:order][:trade_no])

        if order && order.status != 'TRADE_SUCCESS'
          order.update_attributes(status: params[:order][:status])
          render json: { code: 200, msg: order.status }
          return
        end

        render json: { code: 404, msg: 'Unknown trade_no' }
      end

      private

      def order_params
        json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_params['order']['trade_no'] = generate_trade_no
        json_params['order']['ip'] = request.remote_ip

        json_params.require(:order).permit(:amount, 
                                          :created_at, 
                                          :payment_type, 
                                          :trade_no, 
                                          :ip,
                                          :family_id, 
                                          :jail_id, 
                                          :line_items_attributes => [:item_id, :quantity])
      end

      # Generate trade number when create an order.
      # Using timestamp without timezone which after `+`, extracts
      # all numbers of the rest, appends an upcased string of hex.
      #
      # @return [String] of trade number. 
      def generate_trade_no
        order_created_at = Time.now.to_s
        order_created_at.slice(0, order_created_at.index('+')).gsub(/[^\d]/, '') + SecureRandom.hex(4).upcase
      end

    end
  end
end