module SignUtils

  # For WXPay
  SUCCESS_XML = '<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>'
  FAIL_XML = '<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[FAIL]]></return_msg></xml>'

  # To Sign the params of http request 
  # @param hash [Hash] the elements will be signed
  # @param key [String] APP Key of the third party payment platform
  def self.generate_sign(hash, key)
    string = ''

    # signed params sorted by ASIC
    hash.keys.sort.each do |k|
      string +="#{k}=#{hash[k]}&" unless k == 'sign' || hash[k].nil?
    end
    string += key

    Digest::MD5.hexdigest(string.encode('utf-8')).upcase
  end

end
