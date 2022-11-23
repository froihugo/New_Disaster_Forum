class XxxPayDepositService
  attr_reader :url, :auth_key, :pay_key, :merchant_id, :datetime, :notify_url, :errors

  Request_Content_Type = 'application/x-www-form-urlencoded;charset=utf-8'

  def initialize
    @url = 'https://xxxx'
    @auth_key = 'xxxxxx'
    @pay_key = 'xxxxxx'
    @merchant_id = 'xxxxxx'
    @notify_url = 'https://localhost:3000/api/xxx_pay/callback'
    @datetime = DateTime.current.strftime('%Y%m%d%H%M%S')
    @errors = {}
  end

  def deposit(order)
    params = {
      merchantNo: merchant_id,
      merchantUser: order.email,
      merchantOrder: order.serial_number,
      channel: '007002001',
      amount: order.amount,
      currency: :PHP,
      dateTime: datetime
    }
    params = params.merge({ signature: sign(params, pay_key) }, # 签名字串
                          { payerName: '09111111111' },
                          { getPayInfo: :N },
                          {callbackUrl: notify_url})
    raw_response = RestClient.post "#{url}/transaction/deposit",
                                   generate_query_string(params),
                                   {
                                     Authorization: "Bearer #{auth_token}",
                                     'Content-Type': Request_Content_Type
                                   }
    response = JSON.parse(raw_response)
    { url: response['data']['pageUrl'] } if validate_response(response)
  end

  def auth_token
    params = {
      merchantNo: merchant_id,
      dateTime: time
    }
    params[:signature] = sign(params, key)
    raw_response = RestClient.post "#{url}/transaction/withdrawal",
                                   generate_query_string(params),
                                   {
                                     'Content-Type': Request_Content_Type
                                   }
    JSON.parse(raw_response)['data']['auth_token']
  end

  def sign(params, key)
    Digest::MD5.hexdigest((params.values << key).join).downcase
  end

  def generate_query_string(params)
    params.to_query
  end

  def validate_response(response)
    self.errors = {}
    if response['code'] == '0'
      true
    else
      errors['msg'] = response['message']
      errors['success'] = 'false'
      false
    end
  end
end