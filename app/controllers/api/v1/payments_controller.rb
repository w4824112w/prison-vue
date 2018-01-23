require "#{Rails.root}/lib/payment/sign_utils"

module Api
  module V1
    class PaymentsController < ActionController::Base

      # Callback for alipay
      # Example:
      #   某商户设置的通知地址为https://api.xx.com/receive_notify.htm，对应接收到通知的示例如下：
      #   注：以下示例报文仅供参考，实际返回的详细报文请以实际返回为准。
      # 
      #   https://api.xx.com/receive_notify.htm?total_amount=2.00&buyer_id=2088102116773037&body=大乐透2.1&
      #     trade_no=2016071921001003030200089909&refund_fee=0.00&notify_time=2016-07-19 14:10:49&subject=大乐透2.1&
      #     sign_type=RSA2&charset=utf-8&notify_type=trade_status_sync&out_trade_no=0719141034-6418&
      #     gmt_close=2016-07-19 14:10:46&gmt_payment=2016-07-19 14:10:47&trade_status=TRADE_SUCCESS&version=1.0&
      #     sign=kPbQIjX+xQc8F0/A6/AocELIjhhZnGbcBN6G4MM/HmfWL4ZiHM6fWl5NQhzXJusaklZ1LFuMo+lHQUELAYeugH8LYFvxnNajOvZhuxNFbN2LhF0l/
      #          KL8ANtj8oyPM4NN7Qft2kWJTDJUpQOzCzNnV9hDxh5AaT9FPqRS6ZKxnzM=&gmt_create=2016-07-19 14:10:44&app_id=2015102700040153&
      #     seller_id=2088102119685838&notify_id=4a91b7a78a503640467525113fb7d8bg8e
      #
      #   第一步： 在通知返回参数列表中，除去sign、sign_type两个参数外，凡是通知返回回来的参数皆是待验签的参数。
      #   第二步： 将剩下参数进行url_decode, 然后进行字典排序，组成字符串，得到待签名字符串：
      #      `app_id=2015102700040153&body=大乐透2.1&buyer_id=2088102116773037&charset=utf-8&
      #      gmt_close=2016-07-19 14:10:46&gmt_payment=2016-07-19 14:10:47&notify_id=4a91b7a78a503640467525113fb7d8bg8e&
      #      notify_time=2016-07-19 14:10:49&notify_type=trade_status_sync&out_trade_no=0719141034-6418&refund_fee=0.00&
      #      seller_id=2088102119685838&subject=大乐透2.1&total_amount=2.00&trade_no=2016071921001003030200089909&trade_status=TRADE_SUCCESS&version=1.0`
      #
      #   第三步： 将签名参数（sign）使用base64解码为字节码串。
      #   第四步： 使用RSA的验签方法，通过签名字符串、签名参数（经过base64解码）及支付宝公钥验证签名。
      #   第五步：在步骤四验证签名正确后，必须再严格按照如下描述校验通知数据的正确性。
      #     1、商户需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号
      #     2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额）
      #     3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）
      #     4、验证app_id是否为该商户本身。上述1、2、3、4有任何一个验证不通过，则表明本次通知是异常通知，务必忽略。在上述验证通过后商户必须根据支付宝不同类型的业务通知，
      #        正确的进行不同的业务处理，并且过滤重复的通知结果数据。在支付宝的业务通知中，只有交易通知状态为TRADE_SUCCESS或TRADE_FINISHED时，支付宝才会认定为买家付款成功。
      def create
        order = Order.find_by_trade_no(params[:out_trade_no])

        if order
          # TODO: 验证返回数据签名
          if order.process_payment_callback(params[:trade_status], params[:gmt_payment])
            render plain: 'success'
            return
          end

          return render plain: 'failure'
        end

        logger.error "Can not find order #{params[:out_trade_no]}"
        render plain: 'failure'
      end

      def weixin
        hash = Hash.from_xml(request.body.read)['xml']
        logger.debug hash

        order = Order.find_by_trade_no(hash['out_trade_no'])

        if order
          case order.status
          when 'TRADE_SUCCESS'
            logger.debug "WeiXin payment success for order: #{order.trade_no}"
            return render xml: SignUtils::SUCCESS_XML
          when 'WAIT_FOR_NOTIFY', 'WAIT_FOR_PAYMENT'
            if SignUtils.generate_sign(hash, 'key=d75699d893882dea526ea05e9c7a4090') == hash['sign']
              if hash['result_code'] == 'SUCCESS' && hash['return_code'] == 'SUCCESS'
                gmt_string = hash['time_end']

                gmt_payment = Time.new( gmt_string.slice!(0, 4),
                                        gmt_string.slice!(0, 2),
                                        gmt_string.slice!(0, 2),
                                        gmt_string.slice!(0, 2),
                                        gmt_string.slice!(0, 2),
                                        gmt_string )

                if order.process_payment_callback('TRADE_SUCCESS', gmt_payment)
                  logger.info "order #{order.trade_no} payment success" 
                  render xml: SignUtils::SUCCESS_XML 
                  return
                else
                  logger.error "order #{order.trade_no} payment success but update failed, do again."
                end
              else
                logger.error "order #{order.trade_no} payment result was #{hash['result_code']}"
              end
            else
              logger.error "order #{order.trade_no} sign is wrong"
              #render xml: SignUtils::FAIL_XML
              #return
            end
          else
            logger.debug "#{order.trade_no} has an unknown status #{order.status}"
            #render xml: SignUtils::FAIL_XML
            #return 
          end
        else
          logger.error "could not found order: #{hash['out_trade_no']}"
        end

        render xml: SignUtils::FAIL_XML
      end

    end
  end
end