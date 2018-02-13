require 'digest'
require 'net/http'

class YunXin
  APP_KEY = '87dae6933488de4bab789054a3a5c720'
  APP_SECRET = '0022cf3d53fa'

  def initialize
  end  

  # 获取验证码
  def get_code(mobile, &block)
    uri = URI('https://api.netease.im/sms/sendcode.action')
    res = post(uri, :mobile => mobile)
    unless block.nil?
      yield res
      return
    end
    res
  end

  # 校验验证码
  def verify_code(mobile, code)
    uri = URI('https://api.netease.im/sms/verifycode.action')
    post(uri, { mobile: mobile, code: code })
  end

  def generate_accid(accid, name, avatar = nil)
    uri = URI('https://api.netease.im/nimserver/user/create.action')
    post(uri, { accid: accid, name: name, token: accid, icon: avatar })
  end

  def send_message(from, to, body, ope = 0, type = 0)
    uri = URI('https://api.netease.im/nimserver/msg/sendMsg.action')
    post(uri, { from: from, to: to, body: body, ope: ope, type: type })
  end

  def send_sms(templateid, mobiles, params)
    uri = URI('https://api.netease.im/sms/sendtemplate.action')
    post(uri, { templateid: templateid, mobiles: mobiles, params: params })
  end

  private
  
  def encode(nonce, cur_time)
    Digest::SHA1.hexdigest "#{APP_SECRET}#{nonce}#{cur_time}"
  end

  def post(uri, form_data)
    nonce = Random.new.rand(128)
    cur_time = Time.new.to_i

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      req = Net::HTTP::Post.new uri
      req.content_type = 'application/x-www-form-urlencoded'
      req['AppKey'] = APP_KEY
      req['CurTime'] = cur_time
      req['Nonce'] = nonce
      req['CheckSum'] = encode(nonce, cur_time)
      req.set_form_data(form_data)

      begin
        http.request(req)
      rescue Timeout::Error => ex
        return { code: 500, error: ex }
      end      
    end

    res.body
  end
  
end

yunxin = YunXin.new


puts yunxin.generate_accid('611702', '陕西省安康监狱')
